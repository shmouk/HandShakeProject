
import UIKit

class AddUserViewController: UIViewController {
    private let cellId = "cellId"
    private let interfaceBuilder = InterfaceBuilder()
    private let teamViewModel = TeamViewModel()
    private var user: User?
    private var team: Team

    lazy var namingTextField = interfaceBuilder.createTextField()
    lazy var userNameLabel = interfaceBuilder.createTitleLabel()
    lazy var statusLabel = interfaceBuilder.createDescriptionLabel()
    lazy var searchButton = interfaceBuilder.createButton()
    lazy var tableView = interfaceBuilder.createTableView()

    init(team: Team) {
        self.team = team
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
        bindViewModel()
    }
    
    private func setUI() {
        setSubviews()
        setSettings()
        setupConstraints()
        updateNavItem()
        setupTargets()
    }
    
    private func setSettings() {
        settingTextField()
        settingTextLabel()
        settingButton()
        settingTableView()
    }
    
    private func settingButton() {
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
    }
    
    private func settingTextField() {
        namingTextField.delegate = self
        namingTextField.placeholder = "email"
    }
    
    private func settingTextLabel() {
        userNameLabel.text = "Input user email:"
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 2
    }
    
    private func settingTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UsersTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.isScrollEnabled = false
    }
    
    private func setSubviews() {
        view.addSubviews(userNameLabel, namingTextField, searchButton, statusLabel, tableView)
        view.backgroundColor = .colorForView()
    }
    
    private func updateNavItem() {
        let navItem = UINavigationItem(title: "Add user")
        let rightButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addUserAction))
        navItem.rightBarButtonItem = rightButton
        self.navigationItem.setRightBarButton(rightButton, animated: false)
        self.navigationItem.title = navItem.title
        tabBarController?.tabBar.isHidden = true
    }
    
    private func searchUser() {
        guard let text = namingTextField.text else { return }
        teamViewModel.searchUserEmail(text)
    }
    
    private func addUserToTeam() {
        guard let user = user else { return }
        teamViewModel.addUserToTeam(user, to: team) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                AlertManager.showAlert(title: "Success", message: "User added to team", viewController: self)
            case .failure(_):
                break
            }
        }
    }
    
    private func bindViewModel() {
        teamViewModel.fetchUser.bind { [weak self] user in
            guard let self = self else { return }
            self.user = user
            reloadTable()
        }
        
        teamViewModel.satusText.bind { [weak self] text in
            guard let self = self else { return }
            self.statusLabel.text = text
        }
    }
    
    private func reloadTable() {
        tableView.reloadData()
    }
    
    private func setupTargets() {
        searchButton.addTarget(self, action: #selector(searchUserAction), for: .touchUpInside)
    }
}

private extension AddUserViewController {
    @objc
    private func searchUserAction(_ sender: Any) {
        searchUser()
    }
    
    @objc
    private func addUserAction(_ sender: Any) {
        addUserToTeam()
    }
}

extension AddUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        namingTextField.resignFirstResponder()
        return true
    }
}

extension AddUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UsersTableViewCell else { return UITableViewCell() }
        cell.user = user
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        RoundedCellDecorator.roundCorners(for: cell, cornerRadius: 10.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        user != nil ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UsersTableViewCell else { return }
        cell.contentView.backgroundColor = .white
    }
}
