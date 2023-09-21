import UIKit


class Event {
    @objc dynamic var eventId: String
    @objc dynamic var creatorInfo: User
    @objc dynamic var nameEvent: String
    @objc dynamic var descriptionText: String
    @objc dynamic var deadlineState: Int
    @objc dynamic var date: Int
    @objc dynamic var executorInfo: User
    @objc dynamic var readerList: [String]
    @objc dynamic var isReady: Bool
    
    init(eventId: String = "", creatorInfo: User = User(), nameEvent: String = "", descriptionText: String = "", deadlineState: Int = 0, date: Int = 0, executorInfo: User = User(), readerList: [String] = [], isReady: Bool = false) {
        self.eventId = eventId
        self.creatorInfo = creatorInfo
        self.nameEvent = nameEvent
        self.descriptionText = descriptionText
        self.deadlineState = deadlineState
        self.date = date
        self.executorInfo = executorInfo
        self.readerList = readerList
        self.isReady = isReady
    }
}
