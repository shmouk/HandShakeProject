//
//  TeamViewController.swift
//  HandShakeProject
//
//  Created by Марк on 15.07.23.
//

import UIKit

class TeamViewController: UIViewController {
    private let navigationBarManager = NavigationBarManager()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .red
        super.viewDidLoad()
    }
    
    
    private func setUI() {
        setupNavBarManager()
        setSubviews()
//        setupTargets()
    }
    
    private func setupNavBarManager() {
        navigationBarManager.delegate = self
        navigationBarManager.updateNavigationBar(for: self, isAddButtonNeeded: true)
    }
    
    private func setSubviews() {
//        self.register(MessageTableViewCell.self, forCellReuseIdentifier: cellId)
//        self.addSubview(refreshCntrl)
    }
    
    private func openUsersListVC() {
        let usersListTableViewController = TeamCeateViewController()
        navigationController?.pushViewController(usersListTableViewController, animated: true)
    }
    
    deinit {
        print("3")
    }
}

extension TeamViewController: NavigationBarManagerDelegate {
    func didTapNotificationButton() {}
    
    func didTapAddButton() {
        openUsersListVC()
    }
}
