import Firebase
import FirebaseStorage
import UIKit

class TeamAPI: APIClient {
    static var shared = TeamAPI()
    lazy var userAPI = UserAPI.shared
    
    var teams = [Team]() {
        didSet {
            print("new team", teams.count)
            notificationCenterManager.postCustomNotification(named: .teamNotification)
        }
    }
    
    var databaseReferenceData: [DatabaseReference]?
    
    private init() {}
    
    func removeData() {
        removeObserver()
        teams = removeData(data: &teams)
    }
    
    func writeToDatabase(_ teamName: String, completion: @escaping VoidCompletion) {
        let ref = SetupDatabase.setDatabase().child("teams")
        let childRef = ref.childByAutoId()
        
        downloadDefaultImageString(childFolderName: "defaultPhoto", childImageName: "teamDefaultPicture.jpeg") { [weak self] (result) in
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
                completion(.failure(NSError(domain: "Team not created \(error.localizedDescription)", code: 500, userInfo: nil)))
            }
        }
    }
    
    func observeTeams(completion: @escaping VoidCompletion) {
        guard let uid = User.fetchCurrentId() else { return }
        
        let group = DispatchGroup()
        
        let userTeamRef = SetupDatabase.setDatabase().child("user-team").child(uid)
        group.enter()

        userTeamRef.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            if !snapshot.exists() {
                group.leave()
            }
            
            guard let self = self, let usersSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                group.leave()
                completion(.success(()))
                return
            }
            
            let dispatchGroup = DispatchGroup()
            var teamList = [Team]()
            var referenceData = [DatabaseReference]()
            
            for userSnapshot in usersSnapshot {
                let teamId = userSnapshot.key
                let teamReference = SetupDatabase.setDatabase().child("teams").child(teamId)

                referenceData.append(teamReference)
                
                dispatchGroup.enter()
                
                teamReference.observeSingleEvent(of: .value) { [weak self] (snapshot) in
                    guard let self = self,
                        let dict = snapshot.value as? [String: Any],
                        let teamName = dict["teamName"] as? String,
                        let downloadURLString = dict["downloadURL"] as? String,
                        let imageUrl = URL(string: downloadURLString)
                    else {
                        completion(.failure(NSError(domain: "Error retrieving team data", code: 404, userInfo: nil)))
                        dispatchGroup.leave()
                        return
                    }
                    
                    var updatedUserIDs = [String]()
                    var updatedEventListIds = [String]()
                    var creatorId = String()
                    var teamImage: UIImage?
                    
                    dispatchGroup.enter()
                    
                    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                        guard let self = self else { return }
                        self.downloadImage(from: imageUrl) { result in
                            switch result {
                            case .success(let image):
                                teamImage = image
                            case .failure(let error):
                                completion(.failure(error))
                            }
                            dispatchGroup.leave()
                        }
                    }
                    
                    dispatchGroup.enter()
                    
                    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                        guard let self = self else { return }
                        self.fetchUserListData(ref: teamReference) { userIDs, id in
                            updatedUserIDs = userIDs
                            creatorId = id
                            dispatchGroup.leave()
                        }
                    }
                    
                    dispatchGroup.enter()
                    
                    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                        guard let self = self else { return }
                        self.fetchEventListData(ref: teamReference) { eventListIds in
                            updatedEventListIds = eventListIds
                            dispatchGroup.leave()
                        }
                    }
                    
                    dispatchGroup.notify(queue: .global(qos: .userInteractive)) {
                        let team = Team(teamName: teamName, creatorId: creatorId, teamId: teamId, image: teamImage, downloadURL: downloadURLString, userList: updatedUserIDs, eventList: updatedEventListIds)
                        teamList.append(team)
                        print(1, teamList)
                        group.leave()
                    }
                    
                    dispatchGroup.leave()
                }
            }
            
            group.notify(queue: .main) {
                print(2, teamList)
                if !teamList.isEmpty {
                    self.teams = teamList
                    
                    self.startObserveUserListData(refs: referenceData)
                    self.startObserveEventListData(refs: referenceData)
                    self.databaseReferenceData = referenceData
                }
                self.observeNewTeamAndData(ref: userTeamRef, completion: {_ in })
                completion(.success(()))
            }
        }
    }
    
    func fetchEventListData(ref: DatabaseReference, completion: @escaping ([String]) -> Void) {
        let eventListReference = ref.child("eventListId")
        eventListReference.observeSingleEvent(of: .value) { (snapshot) in
            guard let usersSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            var updatedEventListIds = [String]()
            for userSnapshot in usersSnapshot {
                let eventId = userSnapshot.key
                updatedEventListIds.append(eventId)
            }
            DispatchQueue.main.async {
                completion(updatedEventListIds)
            }
        }
    }
    
    func startObserveEventListData(refs: [DatabaseReference]) {
        for ref in refs {
            guard let teamId = ref.key else { continue }
            let eventRef = ref.child("eventListId")
            
            databaseReferenceData?.append(eventRef)

            eventRef.observe(.childAdded) { [weak self] snapshot in
                guard let self = self else { return }
                let eventId = snapshot.key
                self.teams = self.teams.map { team in
                    if team.teamId == teamId, var eventList = team.eventList {
                        if !eventList.contains(eventId) {
                            print(eventId)
                            eventList.append(eventId)
                        }
                        
                        return Team(
                            teamName: team.teamName,
                            creatorId: team.creatorId,
                            teamId: team.teamId,
                            image: team.image,
                            downloadURL: team.downloadURL,
                            userList: team.userList,
                            eventList: eventList
                        )
                    }
                    
                    return team
                }
            }
        }
    }
    
    func fetchUserListData(ref: DatabaseReference, completion: @escaping ([String], String) -> Void) {
        let userListReference = ref.child("userList")
        
        userListReference.observeSingleEvent(of: .value) { (snapshot) in
            var updatedUserIDs: [String] = []
            var creatorId = String()
            
            guard let usersSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            
            for userSnapshot in usersSnapshot {
                let key = userSnapshot.key
                let value = userSnapshot.value as? Int
                
                if value == 1 {
                    creatorId = key
                }
                updatedUserIDs.append(key)
            }
            
            DispatchQueue.main.async {
                completion(updatedUserIDs, creatorId)
            }
        }
    }
    
    func startObserveUserListData(refs: [DatabaseReference]) {
        for ref in refs {
            guard let teamId = ref.key else { continue }
            let userRef = ref.child("userList")
            databaseReferenceData?.append(userRef)

            userRef.observe(.childAdded) { [weak self] snapshot in
                guard let self = self else { return }
                let userId = snapshot.key
                self.teams = self.teams.map { team in
                    if team.teamId == teamId, var userList = team.userList {
                        if !userList.contains(userId) {
                            print(userList)
                            userList.append(userId)
                        }
                        
                        return Team(
                            teamName: team.teamName,
                            creatorId: team.creatorId,
                            teamId: team.teamId,
                            image: team.image,
                            downloadURL: team.downloadURL,
                            userList: userList,
                            eventList: team.eventList
                        )
                    }
                    
                    return team
                }
            }
        }
    }
    
    func observeNewTeamAndData(ref: DatabaseReference, completion: @escaping VoidCompletion) {
        databaseReferenceData?.append(ref)

        ref.observe(.childAdded) { [weak self] snapshot in
            guard let self = self else {
                completion(.success(()))
                return }

            let teamId = snapshot.key
            if !self.teams.contains(where: { $0.teamId == teamId }) {
                let dispatchGroup = DispatchGroup()

                var referenceData = [DatabaseReference]()
                
                let teamReference = SetupDatabase.setDatabase().child("teams").child(teamId)
                
                referenceData.append(teamReference)
                
                dispatchGroup.enter()
                
                teamReference.observeSingleEvent(of: .value) { [weak self] (snapshot) in
                    guard let self = self,
                          let dict = snapshot.value as? [String: Any],
                          let teamName = dict["teamName"] as? String,
                          let downloadURLString = dict["downloadURL"] as? String,
                          let imageUrl = URL(string: downloadURLString)
                    else {
                        completion(.failure(NSError(domain: "Error retrieving team data", code: 404, userInfo: nil)))
                        dispatchGroup.leave()
                        return
                    }
                    
                    var updatedUserIDs = [String]()
                    var updatedEventListIds = [String]()
                    var creatorId = String()
                    var teamImage: UIImage?
                    
                    dispatchGroup.enter()
                    
                    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                        guard let self = self else { return }
                        self.downloadImage(from: imageUrl) { result in
                            switch result {
                            case .success(let image):
                                teamImage = image
                            case .failure(let error):
                                completion(.failure(error))
                            }
                            dispatchGroup.leave()
                        }
                    }
                    
                    dispatchGroup.enter()
                    
                    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                        guard let self = self else { return }
                        self.fetchUserListData(ref: teamReference) { userIDs, id in
                            updatedUserIDs = userIDs
                            creatorId = id
                            dispatchGroup.leave()
                        }
                    }
                    
                    dispatchGroup.enter()
                    
                    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                        guard let self = self else { return }
                        self.fetchEventListData(ref: teamReference) { eventListIds in
                            updatedEventListIds = eventListIds
                            dispatchGroup.leave()
                        }
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        let team = Team(teamName: teamName, creatorId: creatorId, teamId: teamId, image: teamImage, downloadURL: downloadURLString, userList: updatedUserIDs, eventList: updatedEventListIds)
                        self.teams.append(team)
                        self.startObserveUserListData(refs: referenceData)
                        self.startObserveEventListData(refs: referenceData)
                        self.databaseReferenceData?.append(contentsOf: referenceData)
                        completion(.success(()))
                    }
                    dispatchGroup.leave()
                }
            }
        }
    }
    
    func startObserveNewData(ref: DatabaseReference) {
        return
    }
    
    func observeTeams12323(completion: @escaping VoidCompletion) {
        guard let uid = User.fetchCurrentId() else {
            return
        }

        let userTeamRef = SetupDatabase.setDatabase().child("user-team").child(uid)
        userTeamRef.observe(.childAdded, with: { [weak self] (snapshot) in
            guard let self = self else { return }

            let teamId = snapshot.key
            let teamReference = SetupDatabase.setDatabase().child("teams").child(teamId)
            let dispatchGroup = DispatchGroup()

            teamReference.observeSingleEvent(of: .value) { [weak self] (snapshot) in
                guard let self = self,
                      let dict = snapshot.value as? [String: Any],
                      let teamName = dict["teamName"] as? String,
                      let downloadURLString = dict["downloadURL"] as? String,
                      let imageUrl = URL(string: downloadURLString) else {
                    completion(.failure(NSError(domain: "Error retrieving team data", code: 404, userInfo: nil)))
                    return
                }

                var updatedUserIDs: [String] = []
                var updatedEventListIds: [String] = []
                var creatorId = String()
                var teamImage: UIImage?

                dispatchGroup.enter()
                DispatchQueue.main.async {
                    self.downloadImage(from: imageUrl) { [weak self] result in
                        guard let self = self else { return }

                        switch result {
                        case .success(let image):
                            teamImage = image

                            let team = Team(teamName: teamName, creatorId: creatorId, teamId: teamId, image: teamImage, downloadURL: downloadURLString, userList: updatedUserIDs, eventList: updatedEventListIds)
                            self.teams.append(team)

                            dispatchGroup.leave()
                        case .failure(let error):
                            completion(.failure(error))
                            dispatchGroup.leave()
                        }
                    }
                }
                DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                    guard let self = self else { return }
                    let userListReference = teamReference.child("userList")
                    userListReference.observe(.value, with: { [weak self] snapshot in
                        guard let self = self else { return }
                        dispatchGroup.enter()

                        updatedUserIDs.removeAll()
                        for child in snapshot.children {
                            if let childSnapshot = child as? DataSnapshot,
                               let value = childSnapshot.value as? Int {
                                let key = childSnapshot.key
                                if value == 1 {
                                    creatorId = key
                                }
                                updatedUserIDs.append(key)
                            }
                        }

                        self.teams = self.teams.map { team in
                            if team.teamId == teamId {
                                return Team(teamName: team.teamName, creatorId: creatorId, teamId: team.teamId, image: team.image, downloadURL: team.downloadURL, userList: updatedUserIDs, eventList: team.eventList)
                            } else {
                                return team
                            }
                        }
                    })
                }
                DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                    guard let self = self else { return }
                    let eventListReference = teamReference.child("eventListId")
                    eventListReference.observe(.value, with: { [weak self] snapshot in
                        guard let self = self else { return }
                        dispatchGroup.enter()
                        updatedEventListIds.removeAll()
                        for child in snapshot.children {
                            if let childSnapshot = child as? DataSnapshot {
                                let eventId = childSnapshot.key
                                updatedEventListIds.append(eventId)
                            }
                        }

                        self.teams = self.teams.map { team in
                            if team.teamId == teamId {
                                return Team(teamName: team.teamName, creatorId: creatorId, teamId: team.teamId, image: team.image, downloadURL: team.downloadURL, userList: team.userList, eventList: updatedEventListIds)
                            } else {
                                return team
                            }
                        }

                        dispatchGroup.leave()
                    })
                    dispatchGroup.leave()
                }

                dispatchGroup.notify(queue: .main) {
                    completion(.success(()))
                }
            }
        })
    }
    
   
    func searchUserFromDatabase(_ email: String, completion: @escaping (Result<User, Error>) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            if let user = self.userAPI.users.first(where: { $0.email == email }) {
                DispatchQueue.main.async {
                    completion(.success(user))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No user found", code: 404, userInfo: nil)))
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
            completion(.failure(NSError(domain: "Current user is on the user list", code: 500, userInfo: nil)))
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
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let resUsers = self.userAPI.users.filter { teamList.contains($0.uid) }
            
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
            completion(.failure(NSError(domain: "No filter teams found", code: 404, userInfo: nil)))
        }
    }
}

