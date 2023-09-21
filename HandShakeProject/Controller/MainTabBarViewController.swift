import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    deinit {
        print("0")
    }
    
    private func setUI() {
        generateTabBar()
        setupViews()
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
            UINavigationController(rootViewController: eventsViewController),
            UINavigationController(rootViewController: chatViewController),
            UINavigationController(rootViewController: teamViewController),
            UINavigationController(rootViewController: profileViewController)
        ]
    }
    
    
    private func setBarAppearanceUpdate() {
        tabBar.backgroundColor = .white
        tabBar.barStyle = .default
        tabBar.tintColor = .colorForTitleText()
        tabBar.itemPositioning = .fill
    }
    
}

extension MainTabBarViewController {
    @objc
    private func openNotificationAction(_ sender: Any) {
        
    }
    
    @objc
    private func addEventsAction(_ sender: Any) {
        let eventVC = EventCreateViewController()
        eventVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(eventVC, animated: true)
    }
}

extension MainTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}

