import Foundation
import UIKit
import SkeletonView

class ChatViewController: UIViewController {
    private let navigationBarManager = NavigationBarManager()
    private let userNotificationsManager = UserNotificationsManager.shared
    private let cellId = "MessageTableViewCell"
    private let chatViewModel = ChatViewModel()
    private let userViewModel = UserViewModel()
    
    var tableView = InterfaceBuilder.createTableView()
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
            chatViewModel.loadLastMessagePerUser()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.reloadTable()
        }
    }
    
    private func bindViewModel() {
        chatViewModel.lastMessageArray.bind { [weak self] messages in
            guard let self = self else { return }
            self.messages = messages
        }
        chatViewModel.fetchUser.bind { [weak self] user in
            guard let self = self else { return }
            self.user = user
        }
    }
    
    private func setupNavBarManager() {
        tabBarController?.tabBar.isHidden = false
        navigationBarManager.delegate = self
        navigationBarManager.updateNavigationBar(for: self, isLeftButtonNeeded: true)
    }
    
    private func openUsersListVC() {
        userViewModel.observeUsers()
        userViewModel.observeUsersWithoutMe { [weak self] users in
            guard let self = self else { return }
            let usersListTableViewController = UsersListTableViewController(users: users, isCellBeUsed: true)
            usersListTableViewController.delegate = self
            usersListTableViewController.modalPresentationStyle = .automatic
            present(usersListTableViewController, animated: true)
        }
    }
    
    private func openSelectedChat(_ index: Int) {
        chatViewModel.fetchUserFromMessage(index) { [weak self] user in
            guard let self = self else { return }
            self.openChatWithChosenUser(user)
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
        tableView.showSkeleton(usingColor: .skeletonDefault, transition: .crossDissolve(0.5))
    }
    
    private func setSubviews() {
        view.addSubviews(tableView)
        view.backgroundColor = .colorForView()
    }
    
    private func setupTargets() {
    }
}

extension ChatViewController: NavigationBarManagerDelegate {
    func didTapRightButton() {
    }
    
    func didTapAddButton() {
        openUsersListVC()
    }
}

extension ChatViewController: UsersListTableViewControllerDelegate {
    func openChatWithChosenUser(_ user: User) {
        let chatLogController = ChatLogController(user: user)
        navigationController?.pushViewController(chatLogController, animated: true)
    }
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageTableViewCell,
              let message = messages?[indexPath.row] else
        { return UITableViewCell() }
        cell.configure(with: message)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openSelectedChat(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageTableViewCell else { return }
        cell.backgroundColor = .white
    }
}

extension ChatViewController: SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatViewModel.loadMessagesIntoUserDefaults()
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
