import UIKit

class TeamInfoViewController: UIViewController {
    private let teamViewModel = TeamViewModel()
    
    var userListButton = InterfaceBuilder.createButton()
    var editTeamButton = InterfaceBuilder.createButton()
    var creatorID = InterfaceBuilder.createDescriptionLabel()
    var nameLabel = InterfaceBuilder.createTitleLabel()
    var teamImageView = InterfaceBuilder.createImageView()
    
    private let team: Team
    private var users: [User]?
    
    init(team: Team) {
        self.team = team
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadDataIfNeeded()
        setupNavBarManager()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        loadData()
        bindViewModel()
    }
    
    private func setUI() {
        settingButton()
        settingLabel()
        settingImage()
        setSubviews()
        setupConstraints()
        setupTargets()
    }
    
    private func setSubviews() {
        view.addSubviews(teamImageView, creatorID, nameLabel, editTeamButton, userListButton)
        view.backgroundColor = .colorForView()
    }
    
    private func loadData() {
        teamViewModel.convertIdToName(id: team.creatorId)
    }
    
    private func reloadDataIfNeeded() {
        teamViewModel.fetchUsersFromUserList(team: team)
    }
    
    private func bindViewModel() {
        teamViewModel.fetchUsersFromSelectedTeam.bind { [weak self] users in
            guard let self = self else { return }
            self.users = users
        }
        
        teamViewModel.creatorName.bind { [weak self] name in
            guard let self = self else { return }
            creatorID.text = "Creator: " + name
        }
    }
    
    private func settingButton() {
        editTeamButton.setImage(UIImage(systemName: "pencil.line"), for: .normal)
        userListButton.setTitle("User list", for: .normal)
    }
    
    private func settingLabel() {
        nameLabel.text = team.teamName
    }
    
    private func settingImage() {
        teamImageView.image = team.image
    }
    
    private func setupNavBarManager() {
        let navItem = UINavigationItem(title: "Team info")
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "person.badge.plus"), style: .plain, target: self, action: #selector(AddUser))
        navItem.rightBarButtonItem = rightButton
        self.navigationItem.setRightBarButton(rightButton, animated: false)
        self.navigationItem.title = navItem.title
        tabBarController?.tabBar.isHidden = true
    }
    
    private func setupTargets() {
        editTeamButton.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        userListButton.addTarget(self, action: #selector(openUserList), for: .touchUpInside)
    }
    
    private func openUsersListVC() {
        guard let users = users else { return }
        let usersListTableViewController = UsersListTableViewController(users: users, isCellBeUsed: false)
        usersListTableViewController.modalPresentationStyle = .automatic
        present(usersListTableViewController, animated: true)
        
    }
    
    private func openAddUserVC() {
        let addUserViewController = AddUserViewController(team: team)
        navigationController?.pushViewController(addUserViewController, animated: true)
    }
}

// MARK: - Action

private extension TeamInfoViewController {
    
    @objc
    private func openUserList(_ sender: Any) {
        openUsersListVC()
    }
    
    @objc
    private func editProfile(_ sender: Any) {
        AlertManager.showAlert(title: "Warning", message: "Image change not available", viewController: self)
    }
    
    @objc
    private func AddUser(_ sender: Any) {
        openAddUserVC()
    }
}

