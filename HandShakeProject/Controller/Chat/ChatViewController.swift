import Foundation
import UIKit

class ChatViewController: UIViewController {
    private let navigationBarManager = NavigationBarManager()
    private let cellId = "cellId"
    private let userChatViewModel = UserChatViewModel()
    let interfaceBuilder = InterfaceBuilder()
    
    lazy var tableView = interfaceBuilder.createTableView()
    private var user: User?
    private var messages: [Message]?
    private var refreshCntrl = UIRefreshControl()
    
    init() {
        super.init(nibName: nil, bundle: nil)
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
    
    private func setUI() {
        setupNavBarManager()
        setSubviews()
        setupTargets()
        setupConstraints()
    }
    
    private func reloadDataIfNeeded() {
        if messages?.isEmpty ?? true {
            userChatViewModel.loadLastMessagePerUser()
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
        userChatViewModel.loadUsers()
        userChatViewModel.users.bind { [weak self] users in
            guard let self = self else { return }
            let usersListTableViewController = UsersListTableViewController(users: users, isCellBeUsed: true)
            usersListTableViewController.delegate = self
            usersListTableViewController.modalPresentationStyle = .automatic
            present(usersListTableViewController, animated: true)
        }
    }
    
    private func openSelectedChat(_ index: Int) {
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.addSubview(refreshCntrl)
        view.addSubviews(tableView)
        view.backgroundColor = .colorForView()
    }
    
    private func setupTargets() {
        refreshCntrl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
}


extension ChatViewController {
    @objc
    private func handleRefresh(_ sender: UIRefreshControl) {
        userChatViewModel.loadLastMessagePerUser()
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

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        let message = messages?[indexPath.row]
        cell.message = message
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openSelectedChat(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageTableViewCell else { return }
        cell.contentView.backgroundColor = .white
    }
}
