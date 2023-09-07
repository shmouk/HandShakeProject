import UserNotifications

class UserNotificationsManager: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared = UserNotificationsManager()

    private override init() {
        super.init()
        
        UNUserNotificationCenter.current().delegate = self
    }


    // Request user's permission to display notifications
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                // Permission granted
                print("Notification authorization granted.")
            } else {
                // Permission denied
                print("Notification authorization denied.")
            }
        }
    }

    // Schedule a notification
    func scheduleNotification(withTitle title: String, body: String) {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request) { (error) in
            if let error = error {
                print("Failed to schedule notification:", error.localizedDescription)
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

