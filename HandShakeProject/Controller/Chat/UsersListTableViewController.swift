import Foundation
import UIKit


protocol UsersListTableViewControllerDelegate: AnyObject {
    func openChatWithChosenUser(_ user: User)
}

class UsersListTableViewController: UITableViewController {
    let cellId = "cellId"
    weak var delegate: UsersListTableViewControllerDelegate?
    lazy var userChatViewModel = UserChatViewModel()
    var refreshCntrl = UIRefreshControl()
    var users: [User] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UsersTableViewCell else { return UITableViewCell() }
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
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
    
    private func loadData() {
        bindViewModel()
        userChatViewModel.loadUsers()
    }
    
    private func setSubviews() {
        tableView.register(UsersTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.addSubview(refreshCntrl)
    }
    
    private func setupTargets() {
        refreshCntrl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    @objc private func handleRefresh(_ sender: UIRefreshControl) {
        refreshCntrl.endRefreshing()
    }
}

