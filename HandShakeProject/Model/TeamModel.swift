import UIKit
import FirebaseAuth

class Team: NSObject {
    @objc dynamic var teamName: String
    @objc dynamic var creatorId: String
    @objc dynamic var image: UIImage?
    @objc dynamic var downloadURL: String
    @objc dynamic var userList: [String]?
    
    init(teamName: String = "", creatorId: String = "", image: UIImage? = nil, downloadURL: String = "", userList: [String] = []) {
        self.teamName = teamName
        self.creatorId = creatorId
        self.userList = userList
        self.image = image
        self.downloadURL = downloadURL
    }
}
