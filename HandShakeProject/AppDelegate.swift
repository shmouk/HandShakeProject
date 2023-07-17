//
//  AppDelegate.swift
//  HandShakeProject
//
//  Created by Марк on 14.07.23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let coordinator = Coordinator()
        coordinator.start()
        
        return true
    }
}

