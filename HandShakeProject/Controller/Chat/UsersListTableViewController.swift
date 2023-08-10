import Foundation
import UIKit


protocol UsersListTableViewControllerDelegate: AnyObject {
    func openChatWithChosenUser(_ user: User)
}

class UsersListTableViewController: UITableViewController {
    private let cellId = "cellId"
    weak var delegate: UsersListTableViewControllerDelegate?
    private let userChatViewModel = UserChatViewModel()
    private var refreshCntrl = UIRefreshControl()
    private var users: [User]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
        reloadDataIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UsersTableViewCell else { return UITableViewCell() }
        let user = users?[indexPath.row]
        cell.user = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users?[indexPath.row]
        dismiss(animated: true) { [weak self] in
            guard let self = self, let user = user else { return }
            self.delegate?.openChatWithChosenUser(user)
        }
    }
    
    private func setUI() {
        setSubviews()
        setupTargets()
    }
    
    private func bindViewModel() {
        userChatViewModel.users.bind { [weak self] users in
            guard let self = self else { return }
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    private func reloadDataIfNeeded() {
        if users?.isEmpty ?? true {
            userChatViewModel.loadUsers()
            bindViewModel()
        }
    }
    
    private func setSubviews() {
        tableView.register(UsersTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.addSubview(refreshCntrl)
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

