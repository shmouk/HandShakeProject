import UserNotifications
import UIKit

class UserNotificationsManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = UserNotificationsManager()
    weak var currentViewController: UIViewController?
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func registerForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard granted else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    
    func scheduleNotification(withTitle title: String, body: String, delay: TimeInterval = 2) {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                center.add(request)
            } else {
                print("Notification authorization denied.")
            }
        }
    }
    
    func clearAllNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    
       func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
           if let topViewController = UIApplication.topViewController(),
              !(topViewController is ChatLogController) {
               completionHandler([.alert, .sound, .badge])
           } else {
               completionHandler([])
           }
       }
      

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
}




