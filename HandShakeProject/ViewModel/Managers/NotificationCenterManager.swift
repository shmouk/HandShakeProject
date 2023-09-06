import UIKit

class NotificationCenterManager {
    static let shared = NotificationCenterManager()
    
    private init() {}
    
    func postCustomNotification(named notificationName: Notification.Name) {
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func addObserver(_ observer: Any, selector: Selector, forNotification named: Notification.Name) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: named, object: nil)
    }
    
    func removeObserver(_ observer: Any, forNotification named: Notification.Name) {
        NotificationCenter.default.removeObserver(observer, name: named, object: nil)
    }
}

extension Notification.Name {
    static let loadDataNotification = Notification.Name("loadDataNotification")
    static let addProgressNotification = Notification.Name("addProgressNotification")
    static let userNotification = Notification.Name("userNotification")
    static let messageNotification = Notification.Name("messageNotification")
    static let teamNotification = Notification.Name("teamNotification")
    static let eventNotification = Notification.Name("eventNotification")
}

