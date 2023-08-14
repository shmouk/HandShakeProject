import UIKit

class TeamInfoViewController: UIViewController {
    lazy var userListButton = interfaceBuilder.createButton()
    lazy var editTeamButton = interfaceBuilder.createButton()
    lazy var nameLabel = interfaceBuilder.createTitleLabel()
    lazy var teamImageView = interfaceBuilder.createImageView()
    
    private let interfaceBuilder = InterfaceBuilder()
    private let teamViewModel = TeamViewModel()
    let team: Team
    
    init(team: Team) {
        self.team = team
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("4")
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
        setupNavBarManager()
        settingButton()
        settingLabel()
        settingImage()
        setSubviews()
        setupConstraints()
        setupTargets()
    }
    
    private func setSubviews() {
        view.addSubviews(teamImageView, nameLabel, editTeamButton, userListButton)
        view.backgroundColor = .white
    }
    
    private func loadData() {

    }
    
    private func bindViewModel() {
        
    }
    
    private func settingButton() {
        editTeamButton.setImage(UIImage(systemName: "pencil.line"), for: .normal)
        userListButton.setTitle("Users", for: .normal)
    }
    
    private func settingLabel() {
        nameLabel.text = team.teamName
    }
    
    private func settingImage() {
        teamImageView.image = team.image
    }
    
    private func setupNavBarManager() {
        let navItem = UINavigationItem(title: "team info")
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(AddUser))
        navItem.rightBarButtonItem = rightButton
        self.navigationItem.setRightBarButton(rightButton, animated: false)
        self.navigationItem.title = navItem.title
    }
    
    private func setupTargets() {
        editTeamButton.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        userListButton.addTarget(self, action: #selector(openUserList), for: .touchUpInside)
    }
    
    private func openUsersListVC() {
        teamViewModel.fetchUserFromUserList(team: team)
        teamViewModel.fetchUsersFromSelectedTeam.bind { [weak self] users in
            guard let self = self else { return }
            
            let usersListTableViewController = UsersListTableViewController(users: users)
//            usersListTableViewController.delegate = self
            usersListTableViewController.modalPresentationStyle = .automatic
            present(usersListTableViewController, animated: true)
        }
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
        
    }
    
    @objc
    private func AddUser(_ sender: Any) {
        
    }
}

