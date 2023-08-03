
import UIKit

class Message: NSObject {
    @objc dynamic var uid: String
    @objc dynamic var name: String
    @objc dynamic var text: String


    
    init(uid: String = "", name: String = "", text: String = "") {
        self.uid = uid
        self.name = name
        self.text = text
    }
}
