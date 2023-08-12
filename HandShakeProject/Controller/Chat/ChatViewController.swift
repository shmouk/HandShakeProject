import Foundation
import UIKit

class ChatViewController: UITableViewController {
    private let navigationBarManager = NavigationBarManager()
    private let cellId = "cellId"
    private let userChatViewModel = UserChatViewModel()
    private var messages: [Message]?
    private var refreshCntrl = UIRefreshControl()
    
    private var user: User?
    
    init() {
        super.init(style: .plain)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("2")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
        reloadDataIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        let message = messages?[indexPath.row]
        cell.message = message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        openUserChat(index)
    }
    
    private func setUI() {
        setupNavBarManager()
        setSubviews()
        setupTargets()
    }
    
    private func reloadDataIfNeeded() {
        if messages?.isEmpty ?? true {
            userChatViewModel.loadMessages()
        }
    }
    
    private func bindViewModel() {
        userChatViewModel.lastMessageArray.bind { [weak self] messages in
            guard let self = self else { return }
            self.messages = messages
            self.reloadTable()
        }
        userChatViewModel.fetchUser.bind { [weak self] user in
            guard let self = self else { return }
            self.user = user
        }
    }
    
    private func setupNavBarManager() {
        tabBarController?.tabBar.isHidden = false
        navigationBarManager.delegate = self
        navigationBarManager.updateNavigationBar(for: self, isAddButtonNeeded: true)
    }
    
    private func openUsersListVC() {
        let usersListTableViewController = UsersListTableViewController()
        usersListTableViewController.delegate = self
        usersListTableViewController.modalPresentationStyle = .automatic
        present(usersListTableViewController, animated: true)
    }
    
    private func openUserChat(_ index: Int) {
        userChatViewModel.fetchUserFromMessage(index) { [weak self] result in
            guard let self = self, let user = self.user else { return }
            
            switch result {
            case .success():
                self.openChatWithChosenUser(user)
                
            case .failure(_):
                break
            }
        }
    }
    
    private func reloadTable() {
        tableView.reloadData()
    }
    
    private func setSubviews() {
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.addSubview(refreshCntrl)
    }
    
    private func setupTargets() {
        refreshCntrl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
}


extension ChatViewController {
    @objc
    private func handleRefresh(_ sender: UIRefreshControl) {
        userChatViewModel.loadMessages()
        bindViewModel()
        refreshCntrl.endRefreshing()
    }
}

extension ChatViewController: NavigationBarManagerDelegate {
    func didTapNotificationButton() {}
    
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

