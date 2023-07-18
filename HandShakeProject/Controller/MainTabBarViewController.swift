//
//  MainTapBarViewController.swift
//  HandShakeProject
//
//  Created by Марк on 14.07.23.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        generateTabBar()
        addSubviews()
        setupViews()
    }
    
    private func setupViews() {
        delegate = self
        setBarAppearanceUpdate()
    }
    
    private func addSubviews() {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.height / 9))
        navBar.backgroundColor = .yellow
        view.addSubview(navBar)
    }
    
    private func generateTabBar() {
        let eventsViewController = EventsViewController()
        let chatViewController = ChatViewController()
        let teamViewController = TeamViewController()
        let profileViewController = ProfileViewController()

        viewControllers = [
            eventsViewController,
            chatViewController,
            teamViewController,
            profileViewController
        ]
        
        eventsViewController.tabBarItem = UITabBarItem(title: "Events", image: UIImage(systemName: "note.text"), tag: 0)
        chatViewController.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "ellipsis.message"), tag: 1)
        teamViewController.tabBarItem = UITabBarItem(title: "Team", image: UIImage(systemName: "person.3"), tag: 2)
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 3)

        setNavigationItem(for: eventsViewController, title: "Events", name: "bell.badge", isEvents: true)
        setNavigationItem(for: chatViewController, title: "Chats",  isEvents: false)
        setNavigationItem(for: teamViewController, title: "Teams", isEvents: false)
        setNavigationItem(for: profileViewController, title: "Profile", isEvents: false)
    }
    
    private func setNavigationItem(for vc: UIViewController, title: String, name: String = "bell.badge", isEvents: Bool) {
        let image = UIImage(systemName: name)
        vc.title = title
        if isEvents {
            let eventsButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addEventsAction))
            vc.navigationItem.leftBarButtonItem = eventsButton
        }
        let logoutButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(openNotificationAction))
        vc.navigationItem.rightBarButtonItem = logoutButton
    }
    
    private func setBarAppearanceUpdate() {
        tabBar.backgroundColor = .white
        tabBar.barStyle = .default
        tabBar.tintColor = .black
        tabBar.itemPositioning = .fill
        tabBar.barTintColor = .black
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
