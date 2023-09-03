import UIKit

class TeamViewController: UIViewController {
    private let navigationBarManager = NavigationBarManager()
    private let teamViewModel = TeamViewModel()
    private let cellId = "cellId"
    private let interfaceBuilder = InterfaceBuilder()
    
    lazy var tableView = interfaceBuilder.createTableView()
    
    private var sectionTitles = ["Your Teams", "Other Teams"]
    private var firstSectionTeams: [Team]?
    private var secondSectionTeams: [Team]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
        reloadDataIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    deinit {
        print("3")
    }
    
    private func setUI() {
        setupNavBarManager()
        setSubviews()
        settingTableView()
        setupConstraints()
    }
    
    private func setupNavBarManager() {
        navigationBarManager.delegate = self
        navigationBarManager.updateNavigationBar(for: self, isAddButtonNeeded: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    func settingTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TeamTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    private func setSubviews() {
        view.addSubview(tableView)
    }
    
    private func reloadDataIfNeeded() {
        if firstSectionTeams?.isEmpty ?? true || secondSectionTeams?.isEmpty ?? true {
            teamViewModel.filterTeam()
        }
    }
    private func bindViewModel() {
        teamViewModel.ownTeams.bind { [weak self] teams in
            guard let self = self else { return }
            self.firstSectionTeams = teams
            reloadTable()
        }
        teamViewModel.otherTeams.bind { [weak self] teams in
            guard let self = self else { return }
            self.secondSectionTeams = teams 
            reloadTable() 
        }
    }
    
    private func openCreateTeamVC() {
        let usersListTableViewController = TeamCeateViewController()
        navigationController?.pushViewController(usersListTableViewController, animated: true)
    }
    
    private func openSelectedTeamVC(_ selectedTeam: Team) {
        let teamInfoViewController = TeamInfoViewController(team: selectedTeam)
        navigationController?.pushViewController(teamInfoViewController, animated: true)
    }

    private func reloadTable() {
        tableView.reloadData()
    }
    
    private func fetchTeam(_ indexPath: IndexPath) -> Team? {
        var team: Team?

        switch indexPath.section {
        case 0:
            team = firstSectionTeams?[indexPath.row]
        case 1:
            team = secondSectionTeams?[indexPath.row]
        default:
            break
        }
        return team
    }
}

extension TeamViewController: NavigationBarManagerDelegate {
    func didTapNotificationButton() {

    }
    
    func didTapAddButton() {
        if teamViewModel.isTeamExist(teams: firstSectionTeams) {
            AlertManager.showAlert(title: "Failure", message: "You account can create only one team", viewController: self)
        }
        openCreateTeamVC()
    }
}

extension TeamViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return firstSectionTeams?.count ?? 0
        case 1:
            return secondSectionTeams?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? TeamTableViewCell else { return UITableViewCell() }
        cell.team = fetchTeam(indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let team = fetchTeam(indexPath) else { return }
        openSelectedTeamVC(team)
    }
}

