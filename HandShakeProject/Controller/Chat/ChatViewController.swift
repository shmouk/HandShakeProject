import Foundation
import UIKit
import SkeletonView

class ChatViewController: UIViewController {
    private let navigationBarManager = NavigationBarManager()
    private let cellId = "MessageTableViewCell"
    private let userChatViewModel = UserChatViewModel()
    private let interfaceBuilder = InterfaceBuilder()
    private let refreshCntrl = UIRefreshControl()

    lazy var tableView = interfaceBuilder.createTableView()
    
    private var user: User?
    private var messages: [Message]? {
        didSet {
            reloadTable()
        }
    }
    
    
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
        reloadDataIfNeeded()
        setupNavBarManager()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
    }
    
    private func setUI() {
        settingTableView()
        setSubviews()
        setupTargets()
        setupConstraints()
    }
    
    private func reloadDataIfNeeded() {
        if messages?.isEmpty ?? true {
            userChatViewModel.loadLastMessagePerUser()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.reloadTable()
        }
    }
    
    private func bindViewModel() {
        userChatViewModel.lastMessageArray.bind { [weak self] messages in
            guard let self = self else { return }
            self.messages = messages
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
                self.chooseUser(user)
                
            case .failure(_):
                break
            }
        }
    }
    
    private func reloadTable() {
        tableView.stopSkeletonAnimation()
        tableView.hideSkeleton()
        tableView.reloadData()
    }
    
    private func settingTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.addSubview(refreshCntrl)
        tableView.showSkeleton(usingColor: .skeletonDefault, transition: .crossDissolve(0.5))
    }
    
    private func setSubviews() {
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
    func chooseUser(_ user: User) {
        let chatLogController = ChatLogController(user: user)
        navigationController?.pushViewController(chatLogController, animated: true)
    }
}

extension ChatViewController: UITableViewDelegate {
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

extension ChatViewController: SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userChatViewModel.loadMessagesIntoUserDefaults()
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        cellId
    }
    
    private func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
}
