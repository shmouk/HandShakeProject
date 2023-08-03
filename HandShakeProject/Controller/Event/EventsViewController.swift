//
//  EventsViewController.swift
//  HandShakeProject
//
//  Created by Марк on 15.07.23.
//

import UIKit

class EventsViewController: UIViewController {
    private let navigationBarManager = NavigationBarManager()
    lazy var eventCreateViewController = EventCreateViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarManager()
    }
    
    deinit {
        print("1")
    }
    
    func setupNavBarManager() {
        navigationBarManager.delegate = self
        navigationBarManager.updateNavigationBar(for: self, isAddButtonNeeded: true)
    }
}

extension EventsViewController: NavigationBarManagerDelegate {

      func didTapNotificationButton() {
          navigationController?.pushViewController(eventCreateViewController, animated: true)
      }
      
      func didTapAddButton() {
          // Handle add events button tap here
      }

}
