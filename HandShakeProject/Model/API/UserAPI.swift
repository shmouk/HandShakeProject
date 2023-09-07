import UIKit
import Firebase
import FirebaseStorage

class UserAPI: APIClient {
    static let shared = UserAPI()
    
    private init() { }
    
    var users = [User]() {
        didSet {
            notificationCenterManager.postCustomNotification(named: .userNotification)
        }
    }
    var databaseReferenceData: [DatabaseReference]?
    
    func removeData() {
        removeObserver()
        users = removeData(data: &users)
    }
    
    func fetchUser(uid: String? = User.fetchCurrentId(), completion: @escaping UserCompletion) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self,
                  let user = users.first(where: { $0.uid == uid }) else {
                completion(.failure(NSError(domain: "Invalid user data", code: 404, userInfo: nil)))
                return
            }
            DispatchQueue.main.async {
                completion(.success(user))
            }
        }
    }
    
    func observeUsers(completion: @escaping VoidCompletion) {
        guard let currentUid = User.fetchCurrentId() else { return  }
        
        let usersRef = SetupDatabase.setDatabase().child("users")
        let dispatchGroup = DispatchGroup()
        var userList = [User]()
        
        usersRef.observeSingleEvent(of: .value) { (snapshot) in
            guard let usersSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(.success(()))
                return
            }
            
            for userSnapshot in usersSnapshot {
                if let userDict = userSnapshot.value as? [String: Any],
                   let imageUrlString = userDict["downloadURL"] as? String,
                   let imageUrl = URL(string: imageUrlString) {
                    
                    let uid = userSnapshot.key
                    
                    dispatchGroup.enter()
                    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                        guard let self = self else {
                            dispatchGroup.leave()
                            return
                        }
                        
                        self.downloadImage(from: imageUrl) { result in
                            switch result {
                            case .success(let image):
                                let userImage = image
                                
                                let user = User(uid: uid, image: userImage)
                                user.setValuesForKeys(userDict)
                                
                                DispatchQueue.main.async {
                                    userList.append(user)
                                    userList.sort(by: { $0.uid == currentUid && $1.uid != currentUid })
                                    dispatchGroup.leave()
                                }
                                
                            case .failure(let error):
                                DispatchQueue.main.async {
                                    completion(.failure(error))
                                    dispatchGroup.leave()
                                }
                            }
                        }
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) { [weak self] in
                guard let self = self else {
                    completion(.success(()))
                    return
                }
                startObserveNewData(ref: usersRef)
                self.users = userList
                completion(.success(()))
            }
        }
    }


    func startObserveNewData(ref: DatabaseReference) {
        databaseReferenceData = [ref]
        
        ref.observe(.childAdded, with: { (snapshot) in
            guard let userDict = snapshot.value as? [String: Any],
                  let imageUrlString = userDict["downloadURL"] as? String,
                  let imageUrl = URL(string: imageUrlString) else {
                return }
            
            let uid = snapshot.key
            
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let self = self else { return }
                self.downloadImage(from: imageUrl) { result in
                    switch result {
                    case .success(let image):
                        
                        let user = User(uid: uid, image: image)
                        user.setValuesForKeys(userDict)
                        
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            let alreadyAdded = self.users.contains { $0.uid == snapshot.key }

                            if !alreadyAdded {
                                self.users.append(user)
                            }
                        }
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        })
    }
    
    func uploadImageToFirebaseStorage(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let uid = User.fetchCurrentId() else { return }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "Failed to convert image to data", code: 404, userInfo: nil)))
            return
        }
        
        let storageRef = Storage.storage().reference().child("usersPhoto").child(uid)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(error ?? NSError(domain: "Error retrieving download URL", code: 500, userInfo: nil)))
                    return
                }
                
                self.updateUserDownloadURL(uid: uid, downloadURL: downloadURL) { result in
                    switch result {
                    case .success:
                        completion(.success(downloadURL))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    private func updateUserDownloadURL(uid: String, downloadURL: URL, completion: @escaping VoidCompletion) {
        SetupDatabase.setDatabase().child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard var userData = snapshot.value as? [String:Any] else {
                completion(.failure(NSError(domain: "Invalid user data,", code: 400, userInfo: nil)))
                return
            }
            
            userData["downloadURL"] = downloadURL.absoluteString
            
            self.saveUserData(uid: uid, userData: userData) { result in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func saveUserData(uid: String, userData: [String:Any], completion: @escaping VoidCompletion) {
        SetupDatabase.setDatabase().child("users").child(uid).updateChildValues(userData) { error, ref in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func writeToDatabase(uid: String, email: String) {
        let userRef = SetupDatabase.setDatabase().child("users").child(uid)
        
        downloadDefaultImageString(childFolderName: "defaultPhoto", childImageName: "defaultPicture.jpeg") { [weak self] (result) in
            guard self != nil else { return }
            
            switch result {
            case .success(let downloadURL):
                let data = ["downloadURL": downloadURL, "name": "User" + uid.prefix(4), "email": email]
                userRef.setValue(data) { (error, databaseRef) in
                    if let error = error {
                        print("Error writing to database: \(error.localizedDescription)")
                    } else {
                        print("Data written successfully to database")
                    }
                }
                
            case .failure(let error):
                print("Error downloading default image URL: \(error.localizedDescription)")
            }
        }
    }
}
