import UIKit
import SkeletonView

class EventsViewController: UIViewController {
    private let userNotificationsManager = UserNotificationsManager.shared
    private let navigationBarManager = NavigationBarManager()
    private let eventViewModel = EventViewModel()
    private let cellId = "EventTableViewCell"
    private let headerId = "EventHeaderView"
    
    private let interfaceBuilder = InterfaceBuilder()
    
    var tableView = InterfaceBuilder.createTableView()
    var headerView = InterfaceBuilder.createView()

    var eventData: [((UIImage, String), [Event])]? {
        didSet {
            reloadTable()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadDataIfNeeded()
        setupNavBarManager()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    deinit {
        print("1")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestsАfterFirstLaunch()
        setUI()
        bindViewModel()
    }
    
    private func setUI() {
        settingTableView()
        setSubviews()
        setupTargets()
        setupConstraints()
    }
    
    private func requestsАfterFirstLaunch() {
        AlertManager.showAlert(title: "Success", message: "Account successfully login", viewController: self)
    }
    
    private func reloadDataIfNeeded() {
        if eventData?.isEmpty ?? true {
            eventViewModel.fetchEventData()
        }
    }
    
    private func bindViewModel() {
        eventViewModel.eventData.bind { [weak self] data in
            guard let self = self else { return }
            self.eventData = data
        }
    }
    
    private func setupNavBarManager() {
        navigationBarManager.delegate = self
        navigationBarManager.updateNavigationBar(for: self, isLeftButtonNeeded: true, isRightButtonNeeded: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func openEventVC(_ indexPath: IndexPath) {
        guard let event = eventData?[indexPath.section].1[indexPath.row]  else { return }
        
        let eventInfoViewController = EventInfoViewController(event: event)
        eventInfoViewController.modalPresentationStyle = .automatic
        present(eventInfoViewController, animated: true)
    }
    
    private func reloadTable() {
        tableView.reloadData()
    }
    
    private func settingTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(EventHeaderView.self, forHeaderFooterViewReuseIdentifier: headerId)
    }
    
    private func setSubviews() {
        view.addSubviews(tableView)
        view.backgroundColor = .colorForView()
    }
    
    private func setupTargets() {
    }
}

extension EventsViewController: NavigationBarManagerDelegate {
    func didTapRightButton() {
        let helperVC = HelperViewController()
        present(helperVC, animated: true)
    }
    
    func didTapAddButton() {
        let eventCreateViewController = EventCreateViewController()
        navigationController?.pushViewController(eventCreateViewController, animated: true)
    }
}


extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as? EventHeaderView

        headerView?.configure(with: eventData?[section].0)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 94
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return eventData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? EventTableViewCell,
              let events = eventData?[indexPath.section].1 else
        { return UITableViewCell() }
        let event = events[indexPath.row]
        cell.configure(with: event)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.customTableView(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventData?[section].1.count ?? 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openEventVC(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? EventTableViewCell else { return }
        cell.backgroundColor = .white
    }
}




