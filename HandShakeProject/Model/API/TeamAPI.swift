import Firebase
import FirebaseStorage
import UIKit

class TeamAPI: ObservableAPI {
    static var shared = TeamAPI()
    
    var teams = [Team]()
    var observerUIntData: [UInt]?
    
    private init() {}
    
    func removeData() {
        removeObserver()
        teams = removeData(data: &teams)
    }
    
    func writeToDatabase(_ teamName: String, completion: @escaping VoidCompletion) {
        let ref = SetupDatabase.setDatabase().child("teams")
        let childRef = ref.childByAutoId()
        
        downloadDefaultImageString { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let downloadURL):
                guard let teamId = childRef.key, let uid = User.fetchCurrentId() else { return }
                let userListWithIDs: [String: Any] = [uid: 1]
                
                let teamData: [String: Any] = [
                    "teamName": teamName,
                    "teamId": teamId,
                    "downloadURL": downloadURL,
                    "userList": userListWithIDs
                ]
                
                childRef.setValue(teamData) { (error, _) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
                
                let userTeamRef = SetupDatabase.setDatabase().child("user-team").child(uid)
                userTeamRef.updateChildValues([teamId: 1])
                
            case .failure(let error):
                completion(.failure(NSError(domain: "Team not created \(error.localizedDescription)", code: 401, userInfo: nil)))
            }
        }
    }
    
    func observeTeams(completion: @escaping VoidCompletion) {
        guard let uid = User.fetchCurrentId() else {
            completion(.failure(NSError(domain: "No teams found", code: 401, userInfo: nil)))
            return
        }
        
        let dispatchGroup = DispatchGroup()
        
        let observer = SetupDatabase.setDatabase().child("user-team").child(uid).observe(.childAdded, with: { [weak self] (snapshot) in
            guard let self = self else { return }
            
            let teamId = snapshot.key
            
            let teamReference = SetupDatabase.setDatabase().child("teams").child(teamId)
            
            dispatchGroup.enter()
            teamReference.observeSingleEvent(of: .value) { [weak self] (snapshot) in
                guard let self = self,
                      let dict = snapshot.value as? [String: Any],
                      let teamName = dict["teamName"] as? String,
                      let downloadURLString = dict["downloadURL"] as? String,
                      let imageUrl = URL(string: downloadURLString) else {
                    dispatchGroup.leave() // Leave the dispatch group to avoid hanging
                    
                    completion(.failure(NSError(domain: "Error retrieving team data", code: 401, userInfo: nil)))
                    return
                }
                
                var eventListIds: [String] = []
                var userIDs: [String] = []
                var userCreatorID: String?
                var teamImage: UIImage?
                
                dispatchGroup.enter()
                DispatchQueue.main.async { // Dispatch the image download operation to the main queue
                    self.downloadImage(from: imageUrl) { [weak self] result in
                        guard let self = self else { return }
                        
                        switch result {
                        case .success(let image):
                            teamImage = image
                        case .failure(let error):
                            completion(.failure(NSError(domain: "Error fetching team image, \(error.localizedDescription)", code: 500, userInfo: nil)))
                        }
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.enter()
                teamReference.child("eventListId").observeSingleEvent(of: .value) { [weak self] (snapshot) in
                    guard let self = self, let eventId = snapshot.value as? [String: Int] else {
                        dispatchGroup.leave() // Leave the dispatch group to avoid hanging
                        
                        completion(.failure(NSError(domain: "Error retrieving event list", code: 401, userInfo: nil)))
                        return
                    }
                    eventListIds = Array(eventId.keys)
                    dispatchGroup.leave()
                }
                
                dispatchGroup.enter()
                teamReference.child("userList").observeSingleEvent(of: .value) { [weak self] (snapshot) in
                    guard let self = self, let userDict = snapshot.value as? [String: Int] else {
                        dispatchGroup.leave() // Leave the dispatch group to avoid hanging
                        
                        completion(.failure(NSError(domain: "Error retrieving user list", code: 401, userInfo: nil)))
                        return
                    }
                    for (uid, value) in userDict {
                        if value == 1 {
                            userCreatorID = uid
                        }
                        userIDs.append(uid)
                    }
                    dispatchGroup.leave()
                }
                
                dispatchGroup.notify(queue: .main) {
                    let team = Team(teamName: teamName, creatorId: userCreatorID ?? "", teamId: teamId, image: teamImage, downloadURL: downloadURLString, userList: userIDs, eventList: eventListIds)
                    
                    self.teams.append(team)
                    completion(.success(()))
                    
                }
                dispatchGroup.leave()
            }
        })
        observerUIntData = [observer]
    }
    
    func fetchSelectedTeam(_ selectedTeam: Team, completion: @escaping (Team) -> Void) {
        DispatchQueue.main.async { [self] in
            for team in teams {
                if team == selectedTeam {
                    completion(team)
                }
            }
        }
    }
    
    func convertIdToUserName(id: String, completion: @escaping (String) -> Void) {
        let users = UserAPI.shared.users
        DispatchQueue.global().async { [weak self] in
            guard self != nil else { return }
            let userName = users.first { $0.uid == id }?.name ?? ""
            
            DispatchQueue.main.async {
                completion(userName)
            }
        }
    }
    
    func searchUserFromDatabase(_ email: String, completion: @escaping (Result<User, Error>) -> Void) {
        let users = UserAPI.shared.users
        
        DispatchQueue.global().async { [weak self] in
            guard self != nil else { return }
            
            if let user = users.first(where: { $0.email == email }) {
                DispatchQueue.main.async {
                    completion(.success(user))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No user found", code: 500, userInfo: nil)))
                }
            }
        }
    }
    
    func addUserToDatabase(_ user: User, to team: Team, completion: @escaping VoidCompletion) {
        guard let uid = User.fetchCurrentId(), uid == team.creatorId else {
            completion(.failure(NSError(domain: "No permission", code: 403, userInfo: nil)))
            return
        }
        
        if team.userList?.contains(user.uid) ?? false {
            completion(.failure(NSError(domain: "Current user is on the user list", code: 400, userInfo: nil)))
            return
        }
        
        let userId = user.uid
        
        let teamReference = SetupDatabase.setDatabase().child("teams").child(team.teamId).child("userList")
        let teamData: [String: Int] = [
            userId: 0
        ]
        
        let userTeamRef = SetupDatabase.setDatabase().child("user-team").child(userId)
        userTeamRef.updateChildValues([team.teamId: 0])
        
        teamReference.updateChildValues(teamData) { (error, _) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func fetchUserFromTeam(_ team: Team, completion: @escaping ([User]) -> Void) {
        guard let teamList = team.userList else { return }
        let users = UserAPI.shared.users
        DispatchQueue.global().async { [weak self] in
            guard self != nil else { return }
            let resUsers = users.filter { teamList.contains($0.uid) }
            
            DispatchQueue.main.async {
                completion(resUsers)
            }
        }
    }
    
    func filterTeams(completion: @escaping (Result<([Team], [Team]), Error>) -> Void) {
        guard let uid = User.fetchCurrentId() else { return }
        
        var partnerTeams: [Team] = []
        var ownTeams: [Team] = []
        
        for team in teams {
            if team.creatorId == uid {
                ownTeams.append(team)
            } else {
                partnerTeams.append(team)
            }
        }
        
        if !ownTeams.isEmpty || !partnerTeams.isEmpty {
            completion(.success((ownTeams, partnerTeams)))
        } else {
            completion(.failure(NSError(domain: "No filter teams found", code: 401, userInfo: nil)))
        }
    }
    
    private func downloadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? NSError(domain: "Error downloading image", code: 500, userInfo: nil)))
                }
                return
            }
            
            guard let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Invalid image data", code: 400, userInfo: nil)))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }.resume()
    }
    
    private func downloadDefaultImageString(completion: @escaping ResultCompletion) {
        let defaultImageRef = Storage.storage().reference().child("defaultPhoto").child("teamDefaultPicture.jpeg")
        defaultImageRef.downloadURL { url, error in
            guard let imageURL = url else {
                completion(.failure(error ?? NSError(domain: "Error retrieving default image URL", code: 500, userInfo: nil)))
                return
            }
            
            completion(.success(imageURL.absoluteString))
        }
    }
}

