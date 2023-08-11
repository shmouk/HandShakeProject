import UIKit
import FirebaseAuth

class Team: NSObject {
    @objc dynamic var teamId: String
    @objc dynamic var teamName: String
    @objc dynamic var creatorId: String
    @objc dynamic var image: UIImage?
    @objc dynamic var downloadURL: String
    @objc dynamic var userList: [User]?
    
    init(teamId: String = "", teamName: String = "", creatorId: String = "", image: UIImage? = nil, downloadURL: String = "", userList: [User] = []) {
        self.teamId = teamId
        self.teamName = teamName
        self.creatorId = creatorId
        self.userList = userList
        self.image = image
        self.downloadURL = downloadURL
    }
}
