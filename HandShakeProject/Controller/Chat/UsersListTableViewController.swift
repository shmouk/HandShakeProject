import Foundation
import UIKit


protocol UsersListTableViewControllerDelegate: AnyObject {
    func openChatWithChosenUser(_ user: User)
}

class UsersListTableViewController: UIViewController {
    private let cellId = "cellId"
    weak var delegate: UsersListTableViewControllerDelegate?
    private let userChatViewModel = UserChatViewModel()
    private var refreshCntrl = UIRefreshControl()
    private var users: [User]
    
    let interfaceBuilder = InterfaceBuilder()
    
    lazy var tableView = interfaceBuilder.createTableView()
    lazy var titleLabel = interfaceBuilder.createTitleLabel()
    
    init(users: [User]) {
        self.users = users
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
//        reloadDataIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        bindViewModel()
    }
   
    private func setUI() {
        setSubviews()
        setupTargets()
        settingTextLabel()
        setupConstraints()
    }
//
//    private func bindViewModel() {
//        userChatViewModel.users.bind { [weak self] users in
//            guard let self = self else { return }
//            self.users = users
//            self.tableView.reloadData()
//        }
//    }
//
//    private func reloadDataIfNeeded() {
//        if users?.isEmpty ?? true {
//            userChatViewModel.loadUsers()
//            bindViewModel()
//        }
//    }
    
    private func setSubviews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UsersTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.addSubview(refreshCntrl)
        view.addSubviews(titleLabel, tableView)
        view.backgroundColor = .colorForView()
    }
    
    private func settingTextLabel() {
        titleLabel.text = "User list"
        titleLabel.textAlignment = .center
    }
    
    private func setupTargets() {
        refreshCntrl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
}

extension UsersListTableViewController {
    @objc
    private func handleRefresh(_ sender: UIRefreshControl) {
        refreshCntrl.endRefreshing()
    }
}

extension UsersListTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UsersTableViewCell else { return UITableViewCell() }
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.delegate?.openChatWithChosenUser(user)
        }
    }
}

