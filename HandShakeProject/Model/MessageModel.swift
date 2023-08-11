import UIKit

class Message: NSObject {
    @objc dynamic var fromId: String
    @objc dynamic var toId: String
    @objc dynamic var name: String
    @objc dynamic var timeStamp: Int
    @objc dynamic var text: String
    @objc dynamic var image: UIImage?
    
    init(fromId: String = "", toId: String = "", name: String = "", timeStamp: Int = 0, text: String = "", image: UIImage? = nil) {
        self.fromId = fromId
        self.toId = toId
        self.name = name
        self.timeStamp = timeStamp
        self.text = text
        self.image = image
    }
}
