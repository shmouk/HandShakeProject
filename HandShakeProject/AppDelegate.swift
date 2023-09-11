import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var userNotificationsManager = UserNotificationsManager.shared
    lazy var coordinator = Coordinator(UIWindow(frame: UIScreen.main.bounds))
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
       
        coordinator.start()
        
        userNotificationsManager.registerForNotifications()
        
        return true
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        userNotificationsManager.clearAllNotifications()
    }
}

