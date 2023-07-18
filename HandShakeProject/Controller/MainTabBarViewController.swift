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
        generateNavigationItem()
    }
    
    private func setupViews() {
        delegate = self
        setBarAppearanceUpdate()
    }
    
    private func addSubviews() {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
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
    }
    private func generateNavigationItem() {
        guard let vc1 = viewControllers?[0],
        let vc2 = viewControllers?[1],
        let vc3 = viewControllers?[2],
              let vc4 = viewControllers?[3] else { return }

        
        setNavigationItem(for: vc1, title: "Events", name: "bell.badge", isEvents: true)
        setNavigationItem(for: vc2, title: "Chats", name: "bell.badge", isEvents: false)
        setNavigationItem(for: vc3, title: "Teams", name: "bell.badge", isEvents: false)
        setNavigationItem(for: vc4, title: "Profile", name: "bell.badge", isEvents: false)
    }
    
    private func setNavigationItem(for vc: UIViewController, title: String, name: String, isEvents: Bool) {
        let image = UIImage(systemName: name)
        vc.title = title
        if isEvents {
            vc.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addEventsAction))
        }
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(openNotificationAction))
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
