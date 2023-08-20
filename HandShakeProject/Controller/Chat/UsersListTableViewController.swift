import Foundation
import UIKit

protocol UsersListTableViewControllerDelegate: AnyObject {
    func openChatWithChosenUser(_ user: User)
}

class UsersListTableViewController: UIViewController {
    private let cellId = "cellId"
    private let userChatViewModel = UserChatViewModel()
    private let interfaceBuilder = InterfaceBuilder()
    private let users: [User]
    private let isCellBeUsed: Bool
    
    weak var delegate: UsersListTableViewControllerDelegate?

    lazy var tableView = interfaceBuilder.createTableView()
    lazy var titleLabel = interfaceBuilder.createTitleLabel()
    
    init(users: [User], isCellBeUsed: Bool) {
        self.isCellBeUsed = isCellBeUsed
        self.users = users
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    private func setUI() {
        setSubviews()
        setupTargets()
        settingTextLabel()
        setupConstraints()
    }
    
    private func setSubviews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UsersTableViewCell.self, forCellReuseIdentifier: cellId)
        view.addSubviews(titleLabel, tableView)
        view.backgroundColor = .colorForView()
    }
    
    private func settingTextLabel() {
        titleLabel.text = "User list"
        titleLabel.textAlignment = .center
    }
    
    private func setupTargets() {
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
        cell.selectionStyle = isCellBeUsed == true ? .default : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        if isCellBeUsed {
            dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.delegate?.openChatWithChosenUser(user)
            }
        }
    }
}

