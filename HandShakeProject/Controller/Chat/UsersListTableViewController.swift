
import Foundation
import UIKit

protocol UsersListTableViewControllerDelegate: AnyObject {
    func openChatWithChoosenUser(with user: User)
}

class UsersListTableViewController: UITableViewController {
    
    let cellId = "cellId"

    lazy var usersAPI = UsersAPI()
    weak var delegate: UsersListTableViewControllerDelegate?
    
    var refreshCntrl = UIRefreshControl()
    
    init() {
        super.init(style: .plain)
        loadData()
    }
    
    func loadData() {
        usersAPI.fetchUser(completion: { [weak self]_ in
                self?.tableView.reloadData()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("close users")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setSubviews()
        setupTargets()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UsersTableViewCell else { return UITableViewCell() }
        let user = usersAPI.users[indexPath.row]
        cell.user = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersAPI.users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.usersAPI.users[indexPath.row]
        dismiss(animated: true) { [self] in
            delegate?.openChatWithChoosenUser(with: user)
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


