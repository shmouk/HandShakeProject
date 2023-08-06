//
//  ChatViewController.swift
//  HandShakeProject
//
//  Created by Марк on 15.07.23.
//
import FirebaseAuth
import Foundation
import UIKit

class ChatViewController: UITableViewController {
    
    let navigationBarManager = NavigationBarManager()
    let cellId = "cellId"
    
    lazy var chatAPI = ChatAPI()
    lazy var userChatViewModel = UserChatViewModel()

    var refreshCntrl = UIRefreshControl()
    
    init() {
        super.init(style: .plain)
        loadData()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        let message = userChatViewModel.messages?[indexPath.row]
        cell.message = message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userChatViewModel.messages?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        print("fetch")
        userChatViewModel.fetchUserFromMessage(index)
        
        userChatViewModel.user.bind { [weak self] user in
            guard let self = self else { return }
            print("open \(user)")
            self.openChatWithChosenUser(user)
        }
    }

    private func setupNavBarManager() {
        navigationBarManager.delegate = self
        navigationBarManager.updateNavigationBar(for: self, isAddButtonNeeded: true)
    }
    
    private func openUsersListVC() {
        let usersListTableViewController = UsersListTableViewController()
        usersListTableViewController.delegate = self
        usersListTableViewController.modalPresentationStyle = .automatic
        present(usersListTableViewController, animated: true)
    }
    
    private func loadData() {
        userChatViewModel.fetchUserMessage()
    }
    
    private func setSubviews() {
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: cellId)
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

extension ChatViewController: NavigationBarManagerDelegate {
    func didTapNotificationButton() {
        
    }
    
    func didTapAddButton() {
        openUsersListVC()
    }
}

extension ChatViewController: UsersListTableViewControllerDelegate {
    func openChatWithChosenUser(_ user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
}

