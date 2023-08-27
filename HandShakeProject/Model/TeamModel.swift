import UIKit
import FirebaseAuth

class Team: NSObject {
    @objc dynamic var teamName: String
    @objc dynamic var creatorId: String
    @objc dynamic var teamId: String
    @objc dynamic var image: UIImage?
    @objc dynamic var downloadURL: String
    @objc dynamic var userList: [String]?
    @objc dynamic var eventList: [String]?
    
    init(teamName: String = "", creatorId: String = "", teamId: String = "", image: UIImage? = nil, downloadURL: String = "", userList: [String] = [], eventList: [String] = []) {
        self.teamName = teamName
        self.creatorId = creatorId
        self.teamId = teamId
        self.userList = userList
        self.image = image
        self.downloadURL = downloadURL
        self.eventList = eventList
    }
}
