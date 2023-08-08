import Foundation
import UIKit

class ChatViewController: UITableViewController {
    let navigationBarManager = NavigationBarManager()
    let cellId = "cellId"
    let userChatViewModel = UserChatViewModel()
    var refreshCntrl = UIRefreshControl()
    var messages: [Message]?
    var user: User?
    var fetchMessages: Message?

    init() {
        super.init(style: .plain)
        userChatViewModel.loadData()
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
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubviews()
        setupTargets()
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
    }
    
    private func bindViewModel() {
        userChatViewModel.messages.bind { [weak self] messages in
            guard let self = self else { return }
            self.messages = messages
            
            self.tableView.reloadData()
        }
        userChatViewModel.user.bind { [weak self] user in
            guard let self = self else { return }
            self.user = user
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
    
    private func openUserChat(_ index: Int) {
        userChatViewModel.fetchUserFromMessage(index, completion: { [weak self] result in
            guard let self = self, let user = self.user else { return }
            
            switch result {
            case .success():
                self.openChatWithChosenUser(user)
                
            case .failure(let error):
                break
            }
        })
    }
    
    private func loadData() {
        userChatViewModel.loadMessages()
        userChatViewModel.loadUsers()
        bindViewModel()
        reloadTable()
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
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        loadData() 
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

