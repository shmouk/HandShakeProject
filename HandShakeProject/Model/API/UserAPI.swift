import UIKit
import Firebase
import FirebaseStorage

class UserAPI {
    private let database: DatabaseReference
    private let storage: StorageReference
    private let userDefaults = UserDefaultsManager.shared
    
    static var shared = UserAPI()
    
    var users = [User]()
    
    var currentUID: String? {
        didSet {
            print(currentUID)
        }
    }
    
    private init() {
        database = SetupDatabase().setDatabase()
        storage = Storage.storage().reference()
    }
    
    deinit {
        print("deinit UserAPI")
    }
    
    func fetchCurrentUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let uid = self.currentUID else { return }
        
        let userRef = database.child("users").child(uid)
        
        DispatchQueue.global().async {
            userRef.observeSingleEvent(of: .value) { [weak self] snapshot in
                guard let userDict = snapshot.value as? [String: Any] else {
                    let error = NSError(domain: "Invalid user data", code: 400, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                
                if let email = userDict["email"] as? String,
                   let name = userDict["name"] as? String,
                   let imageUrlString = userDict["downloadURL"] as? String,
                   let imageUrl = URL(string: imageUrlString) {
                    guard let self = self else { return }
                    self.downloadImage(from: imageUrl) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let image):
                                let user = User(email: email, name: name, image: image)
                                completion(.success(user))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    }
                } else {
                    let error = NSError(domain: "Invalid user data", code: 400, userInfo: nil)
                    completion(.failure(error))
                }
            }
        }
    }
    
    func observeUsers(completion: @escaping VoidCompletion) {
        currentUID = User.fetchCurrentId()
        
        database.child("users").observe(.childAdded) { [weak self] snapshot in
            guard let userDict = snapshot.value as? [String: Any],
                  let imageUrlString = userDict["downloadURL"] as? String,
                  let imageUrl = URL(string: imageUrlString),
                  let self = self else {
                return
            }
            self.downloadImage(from: imageUrl) { result in
                let uid = snapshot.key
                
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        let user = User(uid: uid, image: image)
                        user.setValuesForKeys(userDict)
                        self.users.append(user)
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
    
    func fetchUserFromChat(_ index: Int, messages: [Message], completion: @escaping (Result<User, Error>) -> Void) {
        guard let uid = self.currentUID else { return }
        guard messages.indices.contains(index) else {
            completion(.failure(NSError(domain: "Invalid index", code: 400, userInfo: nil)))
            return
        }
        let message = messages[index]
        let chatUserId = uid == message.toId ? message.fromId : message.toId
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            guard let user = self.users.first(where: { $0.uid == chatUserId }) else {
                completion(.failure(NSError(domain: "User not found", code: 404, userInfo: nil)))
                return
            }
            DispatchQueue.main.async {
                completion(.success(user))
            }
        }
    }
    
    func uploadImageToFirebaseStorage(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let uid = self.currentUID else { return }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "Failed to convert image to data", code: 400, userInfo: nil)))
            return
        }
        
        let storageRef = storage.child("usersPhoto").child(uid)
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
        database.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard var userData = snapshot.value as? [String:Any] else {
                completion(.failure(NSError(domain: "Invalid user data", code: 400, userInfo: nil)))
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
        database.child("users").child(uid).updateChildValues(userData) { error, ref in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
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
    
    func downloadDefaultImageString(completion: @escaping ResultCompletion) {
        let defaultImageRef = storage.child("defaultPhoto").child("defaultPicture.jpeg")
        defaultImageRef.downloadURL { url, error in
            guard let imageURL = url else {
                completion(.failure(error ?? NSError(domain: "Error retrieving default image URL", code: 500, userInfo: nil)))
                return
            }
            
            completion(.success(imageURL.absoluteString))
        }
    }
    
    func writeToDatabase(uid: String, email: String) {
        let userRef = database.child("users").child(uid)
        
        downloadDefaultImageString { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let downloadURL):
                let data = ["downloadURL": downloadURL, "name": "User" + uid.prefix(4), "email": email]
                userRef.setValue(data) { (error, databaseRef) in
                    if let error = error {
                        print("Error writing to database: \(error.localizedDescription)")
                    } else {
                        print("Data written successfully to database")
                        //                        self.userDefaults.saveValue(data, forKey: "CurrentUserInfo")
                    }
                }
                
            case .failure(let error):
                print("Error downloading default image URL: \(error.localizedDescription)")
            }
        }
    }
}
