import UIKit
import Firebase
import FirebaseStorage

class UsersAPI {
    let database: DatabaseReference
    let storage: StorageReference
    
    var users = [User]()
    
    init() {
        self.database = SetupDatabase().setDatabase()
        self.storage = Storage.storage().reference()
    }
    
    func currentUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            let error = NSError(domain: "Current user is not authenticated", code: 401, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        let userRef = database.child("users").child(uid)
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
                self?.downloadImage(from: imageUrl) { result in
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

    func fetchUser() {
        database.child("users").observe(.childAdded) { [weak self] snapshot in
            guard let userDict = snapshot.value as? [String: Any] else {
                return
            }
            
            if let imageUrlString = userDict["downloadURL"] as? String,
               let imageUrl = URL(string: imageUrlString) {
                self?.downloadImage(from: imageUrl) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let image):
                            let user = User(image: image)
                            user.setValuesForKeys(userDict)
                            self?.users.append(user)
                            print("Success load image")
                            
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    func uploadImageToFirebaseStorage(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "Current user is not authenticated", code: 401, userInfo: nil)))
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "Failed to convert image to data", code: 400, userInfo: nil)))
            return
        }
        
        let storageRef = storage.child("usersPhoto").child(uid)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            guard error == nil else {
                completion(.failure(error!))
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
    
    private func updateUserDownloadURL(uid: String, downloadURL: URL, completion: @escaping (Result<Void, Error>) -> Void) {
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
    
    private func saveUserData(uid: String, userData: [String:Any], completion: @escaping (Result<Void, Error>) -> Void) {
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
    
    func downloadDefaultImageString(completion: @escaping (Result<String, Error>) -> Void) {
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
            guard self != nil else { return }
            
            switch result {
            case .success(let string):
                let data = ["downloadURL": string, "name": "User" + uid, "email": email]
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
