//
//  Coordinator.swift
//  HandShakeProject
//
//  Created by Марк on 17.07.23.
//

import UIKit
import Firebase

class Coordinator {
    
    var window: UIWindow?
    
    func start() {
        
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.overrideUserInterfaceStyle = .light
        
        let authVC = AuthorizationViewController()
        let mainVC = MainTabBarViewController()
        
        authVC.delegate = self
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                self.showViewController(authVC)
            }
            else {
                self.showViewController(mainVC)
            }
        }
        
        window?.rootViewController = authVC
        window?.makeKeyAndVisible()
    }
   
    func showViewController(_ viewController: UIViewController) {
        window?.rootViewController = viewController
    }
}

extension Coordinator: AuthorizationViewControllerDelegate {
    func didLogin() {
        let mainVC = MainTabBarViewController()
        showViewController(mainVC)
    }
}

