//
//  Coordinator.swift
//  HandShakeProject
//
//  Created by Марк on 17.07.23.
//

import UIKit
import FirebaseAuth

class Coordinator {
    
    var window: UIWindow?
    
    func start() {
                
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.overrideUserInterfaceStyle = .light
        
        authStateListener()
        
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
    }
    
    private func authStateListener() {
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
    }
    
    private func showViewController(_ viewController: UIViewController) {
        window?.rootViewController = viewController
    }
}

extension Coordinator: AuthorizationViewControllerDelegate {
    func didLogin() {
        let mainVC = MainTabBarViewController()
        showViewController(mainVC)
    }
}


