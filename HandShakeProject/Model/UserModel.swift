import UIKit

class User: NSObject {
    @objc dynamic var uid: String
    @objc dynamic var email: String
    @objc dynamic var name: String
    @objc dynamic var image: UIImage?
    @objc dynamic var downloadURL: String?

    
    init(uid: String = "", email: String = "", name: String = "", image: UIImage? = nil, downloadURL: String = "") {
        self.uid = uid
        self.email = email
        self.name = name
        self.image = image
        self.downloadURL = downloadURL
    }
}
