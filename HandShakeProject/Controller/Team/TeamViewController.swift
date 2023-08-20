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
        setupConstraints()
    }
    
    private func setupNavBarManager() {
        navigationBarManager.delegate = self
        navigationBarManager.updateNavigationBar(for: self, isAddButtonNeeded: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setSubviews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TeamTableViewCell.self, forCellReuseIdentifier: cellId)
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
        teamViewModel.fetchSelectedTeam(selectedTeam) 
        self.teamViewModel.selectedTeam.bind { [weak self] team in
            guard let self = self else { return }
            let teamInfoViewController = TeamInfoViewController(team: team)
            navigationController?.pushViewController(teamInfoViewController, animated: true)
        }
    }
    
    private func reloadTable() {
        tableView.reloadData()
    }
}

extension TeamViewController: NavigationBarManagerDelegate {
    func didTapNotificationButton() {}
    
    func didTapAddButton() {
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
        switch indexPath.section {
        case 0:
            cell.team = firstSectionTeams?[indexPath.row]
        case 1:
            cell.team = secondSectionTeams?[indexPath.row]
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var team: Team?
        switch indexPath.section {
        case 0:
            let index = indexPath.row
            team = firstSectionTeams?[index]
        case 1:
            let index = indexPath.row
            team = secondSectionTeams?[index]
        default:
            break
        }
        guard let team = team else { return }
        openSelectedTeamVC(team)
    }
}

