import UIKit
import FirebaseAuth

class Coordinator {
    
    private let window: UIWindow
    
    private let authVC = AuthorizationViewController()
    
    init(_ window: UIWindow) {
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


