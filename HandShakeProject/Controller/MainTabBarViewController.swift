import UIKit

class MainTabBarViewController: UITabBarController {
    lazy var navBar = interfaceBuilder.createNavBar()
    let interfaceBuilder = InterfaceBuilder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        generateTabBar()
        addSubviews()
        setupViews()
        setupConstraints()
        updateNavItem()
    }
    
    private func setupViews() {
        delegate = self
        
        setBarAppearanceUpdate()
    }
    
    private func addSubviews() {
        view.addSubview(navBar)
    }
    
    private func generateTabBar() {
        let eventsViewController = EventsViewController()
        eventsViewController.title = "Events"
        eventsViewController.tabBarItem = UITabBarItem(title: "Events", image: UIImage(systemName: "note.text"), tag: 0)
        
        let chatViewController = ChatViewController()
        chatViewController.title = "Chats"
        chatViewController.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "ellipsis.message"), tag: 1)
        
        let teamViewController = TeamViewController()
        teamViewController.title = "Team"
        teamViewController.tabBarItem = UITabBarItem(title: "Team", image: UIImage(systemName: "person.3"), tag: 2)
        
        let profileViewController = ProfileViewController()
        profileViewController.title = "Profile"
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 3)
        
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
        let leftButton = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(addEventsAction))
        
        if selectedIndex == 0 {
            navItem.leftBarButtonItem = leftButton
        }
        
        navItem.rightBarButtonItem = rightButton
        navBar.setItems([navItem], animated: false)
    }
    
    private func setBarAppearanceUpdate() {
        tabBar.backgroundColor = .white
        tabBar.barStyle = .default
        tabBar.tintColor = .colorForText()
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
        print(2)
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

