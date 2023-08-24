//
//  EventsViewController.swift
//  HandShakeProject
//
//  Created by Марк on 15.07.23.
//

import UIKit

class EventsViewController: UIViewController {
    private let navigationBarManager = NavigationBarManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarManager()
    }
    
    deinit {
        print("1")
    }
    
    private func setupNavBarManager() {
        navigationBarManager.delegate = self
        navigationBarManager.updateNavigationBar(for: self, isAddButtonNeeded: true)
        tabBarController?.tabBar.isHidden = false
        view.backgroundColor = .colorForView()
    }
}

extension EventsViewController: NavigationBarManagerDelegate {
      func didTapNotificationButton() {
         
      }
      
      func didTapAddButton() {
          let eventCreateViewController = EventCreateViewController()
          navigationController?.pushViewController(eventCreateViewController, animated: true)
      }
}
