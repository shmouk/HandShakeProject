//
//  AppDelegate.swift
//  HandShakeProject
//
//  Created by Марк on 14.07.23.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let coordinator = Coordinator(window: UIWindow(frame: UIScreen.main.bounds))

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        coordinator.start()
        
        return true
    }
}

