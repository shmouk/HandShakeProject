import Foundation
import UIKit

protocol UsersListTableViewControllerDelegate: AnyObject {
    func openChatWithChosenUser(_ user: User)
}

class UsersListTableViewController: UIViewController {
    private let cellId = "UsersTableViewCell"
    private let userViewModel = UserViewModel()
    private let users: [User]
    private let isCellBeUsed: Bool
    
    weak var delegate: UsersListTableViewControllerDelegate?

    var tableView = InterfaceBuilder.createTableView()
    var titleLabel = InterfaceBuilder.createTitleLabel()
    var closeVCButton = InterfaceBuilder.createButton()

    init(users: [User], isCellBeUsed: Bool) {
        self.isCellBeUsed = isCellBeUsed
        self.users = users
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
   
    private func setUI() {
        setSubviews()
        setupTargets()
        settingTextLabel()
        settingButton()
        settingTableView() 
        setupConstraints()
    }
    func settingTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UsersTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    private func setSubviews() {
        
        view.addSubviews(titleLabel, tableView, closeVCButton)
        view.backgroundColor = .colorForView()
    }
    
    private func settingTextLabel() {
        titleLabel.text = "User list"
        titleLabel.textAlignment = .center
    }
    
    private func settingButton() {
        closeVCButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
    }
    
    private func setupTargets() {
        closeVCButton.addTarget(self, action: #selector(closeVCAction), for: .touchUpInside)
    }
}

extension UsersListTableViewController {
    @objc
    private func closeVCAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension UsersListTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.customTableView(tableView, willDisplay: cell, forRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UsersTableViewCell else { return UITableViewCell() }
        let user = users[indexPath.row]
        cell.configure(with: user)
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

