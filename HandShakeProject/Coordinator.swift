//
//  Coordinator.swift
//  HandShakeProject
//
//  Created by Марк on 17.07.23.
//

import UIKit
import FirebaseAuth

class Coordinator {
    
    private var window: UIWindow
    
    private let authVC = AuthorizationViewController()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.overrideUserInterfaceStyle = .light
        authVC.delegate = self
        window.rootViewController = UINavigationController(rootViewController: authVC)
        window.makeKeyAndVisible()
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


