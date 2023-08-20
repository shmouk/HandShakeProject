import Firebase
import FirebaseStorage
import UIKit

class TeamAPI {
    let database: DatabaseReference
    let storage: StorageReference
    
    var currentUID: String?
    var teams = [Team]()
    
    static var shared = TeamAPI()
    
    private init() {
        database = SetupDatabase().setDatabase()
        storage = Storage.storage().reference()
        fetchCurrentId()
        observeTeams { _ in
            print("load teams")
        }
    }
    
    private func fetchCurrentId() {
        currentUID = User.fetchCurrentId()
    }
    
    private func fetchTeam(teamId: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let teamRef = database.child("teams").child(teamId)
        
        teamRef.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self,
                  let teamDict = snapshot.value as? [String: Any],
                  let imageUrlString = teamDict["downloadURL"] as? String,
                  let imageUrl = URL(string: imageUrlString) else {
                completion(.failure(NSError(domain: "Invalid team data", code: 0, userInfo: nil)))
                return
            }
            
            self.downloadImage(from: imageUrl) { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
    
    func writeToDatabase(_ teamName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let ref = database.child("teams")
        let childRef = ref.childByAutoId()
        
        downloadDefaultImageString { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let downloadURL):
                guard let teamId = childRef.key, let uid = currentUID else { return }
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
                
                let userTeamRef = self.database.child("user-team").child(uid)
                userTeamRef.updateChildValues([teamId: 1])
                
            case .failure(let error):
                completion(.failure(NSError(domain: "No teams found \(error.localizedDescription)", code: 0, userInfo: nil)))
            }
        }
    }
    
    func observeTeams(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = currentUID else { return }
        
        let dispatchGroup = DispatchGroup()
        
        database.child("user-team").child(uid).observe(.childAdded) { [weak self] (snapshot) in
            guard let self = self else { return }
            
            let teamId = snapshot.key
            
            dispatchGroup.enter()
            
            let teamReference = self.database.child("teams").child(teamId)
            
            teamReference.observeSingleEvent(of: .value) { [weak self] (snapshot) in
                guard let self = self,
                      let dict = snapshot.value as? [String: Any],
                      let teamName = dict["teamName"] as? String,
                      let downloadURL = dict["downloadURL"] as? String
                else {
                    completion(.failure(NSError(domain: "Error retrieving team data", code: 0, userInfo: nil)))
                    dispatchGroup.leave()
                    return
                }
                
                var userIDs: [String] = []
                var userCreatorID: String?
                
                self.fetchTeam(teamId: teamId) { [weak self] (result) in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let image):
                        teamReference.child("userList").observeSingleEvent(of: .value) { (snapshot) in
                            guard let users = snapshot.value as? [String: Int] else {
                                completion(.failure(NSError(domain: "Error retrieving user list", code: 0, userInfo: nil)))
                                dispatchGroup.leave()
                                return
                            }
                            
                            for (uid, value) in users {
                                if value == 1 {
                                    userCreatorID = uid
                                }
                                userIDs.append(uid)
                            }
                            let team = Team(teamName: teamName, creatorId: userCreatorID ?? "", teamId: teamId, image: image, downloadURL: downloadURL, userList: userIDs)
                            self.teams.append(team)
                            
                            dispatchGroup.leave()
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            completion(.failure(NSError(domain: "Error fetching team image, \(error.localizedDescription)", code: 0, userInfo: nil)))
                            dispatchGroup.leave()
                        }
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if !self.teams.isEmpty {
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "No teams found", code: 0, userInfo: nil)))
            }
        }
    }
    
    func fetchSelectedTeam(_ selectedTeam: Team, completion: @escaping (Team?) -> Void) {
        guard currentUID != nil else { return }
        var resTeam: Team?
        
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            for team in teams {
                if team == selectedTeam {
                    resTeam = team
                }
                
            }
            DispatchQueue.main.async {
                completion(resTeam)
            }
        }
    }
    func searchUserFromDatabase(_ email: String, completion: @escaping (Result<User, Error>) -> Void) {
        let users = UserAPI.shared.users
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard self != nil else { return }
            
            if let user = users.first(where: { $0.email == email }) {
                DispatchQueue.main.async {
                    completion(.success(user))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No user found", code: 0, userInfo: nil)))
                }
            }
        }
    }
    
    func addUserToDatabase(_ user: User, to team: Team, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUID = currentUID, currentUID == team.creatorId else {
            completion(.failure(NSError(domain: "No permission", code: 0, userInfo: nil)))
            return
        }
        
        if team.userList?.contains(user.uid) ?? false {
            completion(.failure(NSError(domain: "Current user is on the user list", code: 0, userInfo: nil)))
            return
        }
        
        let userId = user.uid
        
        let teamReference = database.child("teams").child(team.teamId).child("userList")
        let teamData: [String: Int] = [
            userId: 0
        ]
        
        let userTeamRef = database.child("user-team").child(userId)
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
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard self != nil else { return }
            let resUsers = users.filter { teamList.contains($0.uid) }
            
            DispatchQueue.main.async {
                completion(resUsers)
            }
        }
    }
    
    func convertIdToUserName(_ id: String, completion: @escaping (String) -> Void) {
        let users = UserAPI.shared.users
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard self != nil else { return }
            let userName = users.first { $0.uid == id }?.name ?? ""
            
            DispatchQueue.main.async {
                completion(userName)
            }
        }
    }
    
    func filterTeams(completion: @escaping (Result<([Team], [Team]), Error>) -> Void) {
        guard let uid = currentUID else { return }
        
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
            completion(.failure(NSError(domain: "No teams found", code: 0, userInfo: nil)))
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
    
    private func downloadDefaultImageString(completion: @escaping (Result<String, Error>) -> Void) {
        let defaultImageRef = storage.child("defaultPhoto").child("teamDefaultPicture.jpeg")
        defaultImageRef.downloadURL { url, error in
            guard let imageURL = url else {
                completion(.failure(error ?? NSError(domain: "Error retrieving default image URL", code: 500, userInfo: nil)))
                return
            }
            
            completion(.success(imageURL.absoluteString))
        }
    }
}

