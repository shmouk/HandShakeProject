import UIKit
import Firebase
import FirebaseStorage

class UserAPI: APIClient {
    static let shared = UserAPI()
    
    private init() { }
    
    var users = [User]()
    var databaseReferanceData: [DatabaseReference]?
    
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
        
        usersRef.observe(.childAdded, with: { [weak self] snapshot in
            guard let self = self,
                  let userDict = snapshot.value as? [String: Any],
                  let imageUrlString = userDict["downloadURL"] as? String,
                  let imageUrl = URL(string: imageUrlString)
            else {
                return
            }
            
            var userImage: UIImage?
            let uid = snapshot.key
            
            dispatchGroup.enter()
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let self = self else { return }
                self.downloadImage(from: imageUrl) { result in
                    switch result {
                    case .success(let image):
                        userImage = image
                        
                        let user = User(uid: uid, image: userImage)
                        user.setValuesForKeys(userDict)
                        
                        dispatchGroup.enter()
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.users.append(user)
                            self.users.sort(by: { $0.uid == currentUid && $1.uid != currentUid })
                            dispatchGroup.leave()
                        }
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                    dispatchGroup.leave()
                }
            }
        })
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            completion(.success(()))
        }
        databaseReferanceData = [usersRef]
    }
    
    
    
    //    func observeUsers1(completion: @escaping VoidCompletion) {
    //        let usersRef = SetupDatabase.setDatabase().child("users")
    //        let dispatchGroup = DispatchGroup()  // Создаем DispatchGroup
    //
    //        usersRef.observe(.childAdded, with: { [weak self] snapshot in
    //            guard let userDict = snapshot.value as? [String: Any],
    //                  let imageUrlString = userDict["downloadURL"] as? String,
    //                  let imageUrl = URL(string: imageUrlString),
    //                  let self = self else {
    //                return
    //            }
    //
    //            dispatchGroup.enter()  // Уведомляем DispatchGroup о входе в блок кода
    //
    //            self.downloadImage(from: imageUrl) { result in
    //                let uid = snapshot.key
    //
    //                switch result {
    //                case .success(let image):
    //                    DispatchQueue.main.async {
    //                        let user = User(uid: uid, image: image)
    //                        user.setValuesForKeys(userDict)
    //                        self.users.append(user)
    //                        print(1)
    //                        dispatchGroup.leave()  // Уведомляем DispatchGroup о выходе из блока кода
    //                    }
    //                case .failure(let error):
    //                    DispatchQueue.main.async {
    //                        completion(.failure(error))
    //                        dispatchGroup.leave()  // Уведомляем DispatchGroup о выходе из блока кода
    //                    }
    //                }
    //            }
    //        })
    //
    //        dispatchGroup.notify(queue: .main) {
    //            // Все данные в usersRef.observe полностью загружены
    //            print(2)
    //            completion(.success(()))
    //        }
    //
    //        databaseReferanceData = [usersRef]
    //    }
    
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
