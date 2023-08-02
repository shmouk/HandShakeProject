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
    
    private let authVC = AuthorizationViewController()
    
    func start() {
                
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.overrideUserInterfaceStyle = .light
        authVC.delegate = self
        window?.rootViewController = UINavigationController(rootViewController: authVC)
        window?.makeKeyAndVisible()
    }
    
    private func showViewController() {
        let mainVC = MainTabBarViewController()
        authVC.navigationController?.pushViewController(mainVC, animated: true)
    }
}

extension Coordinator: AuthorizationViewControllerDelegate {
    func didLogin() {
        showViewController()
    }
}


