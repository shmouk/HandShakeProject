import UIKit
import Firebase
import FirebaseStorage


class UsersAPI {
    
    var database = SetupDatabase().setDatabase()
    var users = [User]()


    func currentUser(completion: @escaping ([String: String]?) -> Void) {
        var currentUserDict: [String: String] = [:]
        
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        database.child("users").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            guard let self = self else {
                completion(nil)
                return
            }
            
            if let userDict = snapshot.value as? [String: Any],
               let userDict = userDict[currentUserUID] as? [String: Any],
               let email = userDict["email"] as? String,
               let name = userDict["name"] as? String {
                currentUserDict["email"] = email
                currentUserDict["name"] = name
                completion(currentUserDict)
            } else {
                completion(nil)
            }
        })
    }
    
    func fetchUser() {
        database.child("users").observe(.childAdded) { [self](snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeys(dictionary)
                users.append(user)
            }
        }
    }
    
    func loadImageFromFirebaseStorage(completion: @escaping (UIImage?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        let uid = currentUser.uid
    
        let storageRef = Storage.storage().reference().child("profilePhoto").child(uid)
        
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error when uploading photo: \(error.localizedDescription)")
                completion(nil)
            } else {
                if let imageData = data, let image = UIImage(data: imageData) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
    }

    func uploadImageToFirebaseStorage(image: UIImage) {
        guard let currentUser = Auth.auth().currentUser else {
            print("Current user is not authenticated")
            return
        }

        let uid = currentUser.uid
        let storageRef = Storage.storage().reference().child("profilePhoto").child(uid)
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to data")
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            guard error == nil else {
                print("Error uploading image: \(error!.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("Error retrieving download URL: \(error!.localizedDescription)")
                    return
                }
                
                print("Image uploaded successfully. Download URL: \(downloadURL)")
            }
        }
    }
    
    
    
    func writeToDatabase(uid: String, email: String) {
        
        let userRef = database.child("users").child(uid)
        
        let data = ["name": "User" + uid, "email": email]
        
        userRef.setValue(data) { (error, databaseRef) in
            if let error = error {
                print("Error writing user to Firebase: \(error.localizedDescription)")
            } else {
                print("User data successfully written to Firebase")
            }
        }
    }
}
