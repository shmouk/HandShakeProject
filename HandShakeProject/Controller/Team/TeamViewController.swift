//
//  TeamViewController.swift
//  HandShakeProject
//
//  Created by Марк on 15.07.23.
//

import UIKit

class TeamViewController: UIViewController {
    private let navigationBarManager = NavigationBarManager()
    private let teamViewModel = TeamViewModel()
    private let cellId = "cellId"
    
    let interfaceBuilder = InterfaceBuilder()
    
    private lazy var tableView = interfaceBuilder.createTableView()
    
    private var sectionTitles: [String] = []
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
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
            sectionTitles = teamViewModel.settingSections()
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
    
    private func openUsersListVC() {
        let usersListTableViewController = TeamCeateViewController()
        navigationController?.pushViewController(usersListTableViewController, animated: true)
    }
    
    private func reloadTable() {
        tableView.reloadData()
    }
}

extension TeamViewController: NavigationBarManagerDelegate {
    func didTapNotificationButton() {}
    
    func didTapAddButton() {
        openUsersListVC()
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
        default:
            return secondSectionTeams?.count ?? 0
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
        default:
            cell.team = secondSectionTeams?[indexPath.row]
        }
        return cell
    }
}

