import UIKit
import FirebaseAuth

class User: NSObject {
    @objc dynamic var uid: String
    @objc dynamic var email: String
    @objc dynamic var name: String
    @objc dynamic var image: UIImage?
    @objc dynamic var downloadURL: String

    
    init(uid: String = "", email: String = "", name: String = "", image: UIImage? = UIImage(), downloadURL: String = "") {
        self.uid = uid
        self.email = email
        self.name = name
        self.image = image
        self.downloadURL = downloadURL
    }
    
    static func fetchCurrentId() -> String? {
        guard let uid = Auth.auth().currentUser?.uid else {
            let error = NSError(domain: "Current user is not authenticated", code: 403, userInfo: nil)
            return nil
        }
        return uid
    }
}


