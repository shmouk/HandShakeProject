//
//  AppDelegate.swift
//  HandShakeProject
//
//  Created by Марк on 14.07.23.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    FirebaseApp.configure()
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                self.showAuthViewController()
            }
            else {
                self.showMainViewController()
            }
        }
        window?.makeKeyAndVisible()

        return true
    }
    
    func showAuthViewController() {
        self.window?.rootViewController? = AuthorizationViewController()
    }
    
    func showMainViewController() {
        self.window?.rootViewController? = MainTabBarViewController()
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

