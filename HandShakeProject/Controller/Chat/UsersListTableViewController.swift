
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
    var users: [User]?
    
    init() {
        super.init(style: .plain)
        userChatViewModel.fetchUsers()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setSubviews()
        setupTargets()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UsersTableViewCell else { return UITableViewCell() }
        let user = userChatViewModel.users?[indexPath.row]
        cell.user = user
        print("userlist load \(users)")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  userChatViewModel.users?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = self.userChatViewModel.users?[indexPath.row] else { return }
        dismiss(animated: true) { [self] in
            delegate?.openChatWithChosenUser(user)
        }
    }
    private func setSubviews() {
        tableView.register(UsersTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.addSubviews(refreshCntrl)
    }
    
    private func setupTargets() {
        refreshCntrl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
}

extension UsersListTableViewController {
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        tableView.reloadData()
        
        refreshCntrl.endRefreshing()
    }
}


