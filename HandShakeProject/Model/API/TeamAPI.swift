import Firebase
import FirebaseStorage
import UIKit

class TeamAPI {
    let database: DatabaseReference
    let storage: StorageReference
    
    var lastMessageFromMessages = [Message]()
    var allMessages = [Message]()
    var currentUID: String?
 
    static var shared = TeamAPI()
    
    typealias TeamCompletion = (Result<(UIImage, String), Error>) -> Void
    
    private init() {
        database = SetupDatabase().setDatabase()
        storage = Storage.storage().reference()
        fetchCurrentId()
    }
    
    private func fetchCurrentId() {
        currentUID = User.fetchCurrentId()
    }
    
    private func fetchTeam(teamId: String, completion: @escaping TeamCompletion) {
        database.child("teams").child(teamId).observeSingleEvent(of: .value) { snapshot in
            guard let userDict = snapshot.value as? [String: Any],
                  let imageUrlString = userDict["downloadURL"] as? String,
                  let teamName = userDict["teamName"] as? String,
                  let imageUrl = URL(string: imageUrlString) else {
                return
            }
            
            self.downloadImage(from: imageUrl) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        completion(.success((image, teamName)))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
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
                guard let teamID = childRef.key, let uid = currentUID else { return }
                var userListWithIDs: [String: Any] = ["userList": ""]
            
                let teamData: [String: Any] = [
                    "teamName": teamName,
                    "downloadURL": downloadURL,
                    "userList": userListWithIDs,
                    "currentID": uid
                ]
                
                childRef.setValue(teamData) { (error, _) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    func observeTeams(completion: @escaping (Result<Void, Error>) -> Void) {
            guard let uid = currentUID else { return }
            
            var teamDictionary = [String : Team]()
            let teamRef = database.child("team-users").child(uid)
            
            teamRef.observe(.childAdded) { [weak self] (snapshot) in
                guard let self = self else { return }
                let teamId = snapshot.key
                let teamReference = self.database.child("teams").child(teamId)
                
                teamReference.observeSingleEvent(of: .value) { [weak self] (snapshot) in
                    guard let self = self else { return }
                    
                    guard let dict = snapshot.value as? [String: Any],
                          let teamName = dict["teamName"] as? String,
                          let creatorId = dict["creatorId"] as? String,
                          let downloadURL = dict["downloadURL"] as? String else {
                        return
                    }
                    
                    self.fetchTeam(teamId: uid) { [weak self] (result) in
                        guard let self = self else { return }
                        
                        switch result {
                        case .success(let (image, name)):
                            DispatchQueue.main.async {
                                
                                completion(.success(()))
                            }
                            
                        case .failure(let error):
                            DispatchQueue.main.async {
                                completion(.failure(error))
                            }
                        }
                    }
                }
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
    
    func downloadDefaultImageString(completion: @escaping (Result<String, Error>) -> Void) {
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

