import UIKit
import SkeletonView

class EventsViewController: UIViewController {
    private let navigationBarManager = NavigationBarManager()
    private let eventViewModel = EventViewModel()
    private let cellId = "EventTableViewCell"
    private let headerId = "EventHeaderView"
    
    private let interfaceBuilder = InterfaceBuilder()
    
    lazy var tableView = interfaceBuilder.createTableView()
    lazy var headerView = interfaceBuilder.createView()

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
    
    deinit {
        print("1")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
    }
    
    private func setUI() {
        settingTableView()
        setSubviews()
        setupTargets()
        setupConstraints()
    }
    
    private func reloadDataIfNeeded() {
        if eventData?.isEmpty ?? true {
            eventViewModel.fetchEventData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.reloadTable()
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
        navigationBarManager.updateNavigationBar(for: self, isAddButtonNeeded: true)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func openEventVC(_ indexPath: IndexPath) {
        guard let event = eventData?[indexPath.section].1[indexPath.row]  else { return }
        
        let eventInfoViewController = EventInfoViewController(event: event)
        eventInfoViewController.modalPresentationStyle = .automatic
        present(eventInfoViewController, animated: true)
    }
    
    private func reloadTable() {
        tableView.stopSkeletonAnimation()
        tableView.hideSkeleton()
        tableView.reloadData()
    }
    
    private func settingTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.register(EventHeaderView.self, forHeaderFooterViewReuseIdentifier: headerId)
        tableView.showSkeleton(usingColor: .skeletonDefault, transition: .crossDissolve(0.5))
    }
    
    private func setSubviews() {
        view.addSubviews(tableView)
        view.backgroundColor = .colorForView()
    }
    
    private func setupTargets() {
    }
}

extension EventsViewController: NavigationBarManagerDelegate {
    func didTapNotificationButton() {
        self.reloadTable()
    }
    
    func didTapAddButton() {
        let eventCreateViewController = EventCreateViewController()
        navigationController?.pushViewController(eventCreateViewController, animated: true)
    }
}


extension EventsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as? EventHeaderView
        headerView?.teamInfo = eventData?[section].0
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 82
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return eventData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? EventTableViewCell else { return UITableViewCell() }
        let events = eventData?[indexPath.section].1
        cell.event = events?[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventData?[section].1.count ?? 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        openEventVC(indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? EventTableViewCell else { return }
        cell.contentView.backgroundColor = .white
    }
}

extension EventsViewController: SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        cellId
    }
    
    private func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
}





