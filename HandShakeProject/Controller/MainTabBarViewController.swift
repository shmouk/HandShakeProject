import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        generateTabBar()
        setupViews()
        updateNavItem()
    }
    
    private func setupViews() {
        delegate = self
        setBarAppearanceUpdate()
    }
    
    private func generateTabBar() {
        let eventsViewController = EventsViewController()
        let chatViewController = ChatViewController()
        let teamViewController = TeamViewController()
        let profileViewController = ProfileViewController()
        
        
        eventsViewController.tabBarItem = UITabBarItem(title: "Events", image: UIImage(systemName: "note.text"), tag: 0)
        chatViewController.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "ellipsis.message"), tag: 1)
        teamViewController.tabBarItem = UITabBarItem(title: "Team", image: UIImage(systemName: "person.3"), tag: 2)
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 3)
        
        eventsViewController.title = "Events"
        chatViewController.title = "Chats"
        teamViewController.title = "Team"
        profileViewController.title = "Profile"
        
        
        viewControllers = [
            eventsViewController,
            chatViewController,
            teamViewController,
            profileViewController
        ]
    }
    
    private func updateNavItem() {
        let selectedViewController = viewControllers?[selectedIndex]
        let navItem = UINavigationItem(title: selectedViewController?.title ?? "")
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(openNotificationAction))
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addEventsAction))
        
        if selectedIndex != 0 {
            navItem.leftBarButtonItem = nil
            self.navigationItem.setLeftBarButton(nil, animated: false)
        } else {
            navItem.leftBarButtonItem = leftButton
            self.navigationItem.setLeftBarButton(leftButton, animated: false)
        }
        
        navItem.rightBarButtonItem = rightButton
        self.navigationItem.setRightBarButton(rightButton, animated: false)
        self.navigationItem.title = navItem.title
    }
    
    private func setBarAppearanceUpdate() {
        tabBar.backgroundColor = .white
        tabBar.barStyle = .default
        tabBar.tintColor = .colorForTitleText()
        tabBar.itemPositioning = .fill
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateNavItem()
    }
    
}

extension MainTabBarViewController {
    @objc
    private func openNotificationAction(_ sender: Any) {
        print(1)
    }
    
    @objc
    private func addEventsAction(_ sender: Any) {
        let eventVC = EventCreateViewController()
        eventVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(eventVC, animated: true)
        //        present(eventVC, animated: true)
    }
}

extension MainTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else { return false }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionCrossDissolve], completion: nil)
        }
        
        return true
    }
}

