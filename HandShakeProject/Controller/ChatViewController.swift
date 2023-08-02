//
//  ChatViewController.swift
//  HandShakeProject
//
//  Created by Марк on 15.07.23.
//

import Foundation
import UIKit

protocol ChatViewControllerDelegate: AnyObject {
    func openChatWithChoosenUser(user: User)
}

class ChatViewController: UITableViewController {
    
    let navigationBarManager = NavigationBarManager()
    let cellId = "cellId"
    
    lazy var usersAPI = UsersAPI()
    var refreshCntrl = UIRefreshControl()
    var usersListTableViewController = UsersListTableViewController()
    weak var chatLogController: ChatLogController?
    
    init() {
        super.init(style: .plain)
//        usersAPI.fetchUser()
        usersListTableViewController.delegate = self
        tableView.register(ChatsTableVeiwCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("2")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarManager()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews()
        setupTargets()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ChatsTableVeiwCell else { return UITableViewCell() }
        let user = usersAPI.users[indexPath.row]
        cell.user = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersAPI.users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.usersAPI.users[indexPath.row]
    }
    
    private func setupNavBarManager() {
        navigationBarManager.delegate = self
        navigationBarManager.updateNavigationBar(for: self, isAddButtonNeeded: true)
    }
    

    
    private func setSubviews() {
        tableView.addSubviews(refreshCntrl)
    }
    
    private func setupTargets() {
        refreshCntrl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
}

extension ChatViewController {
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        tableView.reloadData()
        
        refreshCntrl.endRefreshing()
    }
}

extension ChatViewController: ChatViewControllerDelegate {
    func openChatWithChoosenUser(user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
}

extension ChatViewController: NavigationBarManagerDelegate {
    
    func didTapNotificationButton() {
        
    }
    
    func didTapAddEventsButton() {
        let usersListTableViewController = UsersListTableViewController()
//        navigationController?.pushViewController(usersListTableViewController, animated: true)
        usersListTableViewController.modalPresentationStyle = .fullScreen
        present(usersListTableViewController, animated: true)
        
    }
}

