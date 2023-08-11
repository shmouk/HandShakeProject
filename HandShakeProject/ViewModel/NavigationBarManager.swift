//
//  NavigationBarManager.swift
//  HandShakeProject
//
//  Created by Марк on 3.08.23.
//

import UIKit

protocol NavigationBarManagerDelegate: AnyObject {
    func didTapNotificationButton()
    func didTapAddButton()
}

class NavigationBarManager {
    weak var delegate: NavigationBarManagerDelegate?
    
    func updateNavigationBar(for viewController: UIViewController, isAddButtonNeeded: Bool) {
        guard let navigationController = viewController.navigationController else {
            return
        }
        navigationController.setupNavBarAppearance()
        
        let navigationBar = navigationController.navigationBar
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(handleNotificationButton))
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(handleAddEventsButton))
        
        viewController.navigationItem.leftBarButtonItems = [leftButton]
        viewController.navigationItem.rightBarButtonItem = rightButton
        viewController.navigationItem.title = viewController.title ?? ""
        
        navigationBar.isHidden = false
        
        if isAddButtonNeeded {
            viewController.navigationItem.leftBarButtonItems?.first?.isHidden = false
        } else {
            viewController.navigationItem.leftBarButtonItems?.first?.isHidden = true
        }
    }
    
    @objc func handleNotificationButton() {
        delegate?.didTapNotificationButton()
    }
    
    @objc func handleAddEventsButton() {
        delegate?.didTapAddButton()
    }
}

