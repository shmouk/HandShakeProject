import UIKit

class User: NSObject {
    @objc dynamic var email: String
    @objc dynamic var name: String
    @objc dynamic var image: UIImage?
    @objc dynamic var downloadURL: String

    
    init(email: String = "", name: String = "", image: UIImage? = nil, downloadURL: String = "") {
        self.email = email
        self.name = name
        self.image = image
        self.downloadURL = downloadURL
    }
}
