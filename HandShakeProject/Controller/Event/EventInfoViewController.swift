import UIKit

class EventInfoViewController: UIViewController {
    private let eventViewModel = EventViewModel()
    private let cellId = "UsersTableViewCell"

    var nameLabel = InterfaceBuilder.createTitleLabel()
    var stateView = InterfaceBuilder.createView()
    var dateLabel = InterfaceBuilder.createTitleLabel()
    var creatorImageView = InterfaceBuilder.createImageView()
    var creatorNameLabel = InterfaceBuilder.createTitleLabel()
    var descriptionTextView = InterfaceBuilder.createTextView()
    var executorTitleLabel = InterfaceBuilder.createTitleLabel()
    var tableView = InterfaceBuilder.createTableView()
    var readerTitleLabel = InterfaceBuilder.createTitleLabel()
    var readerTextView = InterfaceBuilder.createTextView()
    var readyButton = InterfaceBuilder.createButton()
    var closeVCButton = InterfaceBuilder.createButton()

    private let event: Event
    
    init(event: Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        loadData()
        bindViewModel()
    }
    
    private func setUI() {
        setSetting()
        setSubviews()
        setupConstraints()
        setupTargets()
    }
    
    private func setSetting() {
        settingTableView()
        settingButton()
        settingLabel()
        settingView()
        settingImage()
        settingTextView()
    }
    
    private func settingTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(UsersTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    private func setSubviews() {
        view.addSubviews(stateView, nameLabel, dateLabel, creatorImageView, readerTitleLabel, executorTitleLabel, creatorNameLabel, descriptionTextView, tableView, readerTextView, readyButton, closeVCButton)
    }
    
    private func loadData() {
        eventViewModel.convertIdToNames(ids: event.readerList)
    }
    
    private func bindViewModel() {
        eventViewModel.userNames.bind { [weak self] names in
            guard let self = self else { return }
            readerTextView.text = "Everyone"
//            readerTextView.text = names.joined(separator: ", ")
        }
    }
    
    private func settingButton() {
        closeVCButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        readyButton.setTitle("Ready", for: .normal)
        eventViewModel.checkExecutor(event: event) { isExecutor in
            print(isExecutor)
            readyButton.isEnabled = isExecutor
        }
    }
    
    private func settingLabel() {
        creatorNameLabel.text = event.creatorInfo.name + ":"
        executorTitleLabel.text = "Executor:"
        readerTitleLabel.text = "Readers:"
        nameLabel.text = event.nameEvent
        dateLabel.text = "Deadline to: " + event.date.convertTimestampToDate(timeStyle: .medium)
        
        [creatorNameLabel, nameLabel, dateLabel].forEach({ $0.textAlignment  = .center })
    }
    
    private func settingTextView() {
        descriptionTextView.text = event.descriptionText
    }
    
    private func settingImage() {
        creatorImageView.image = event.creatorInfo.image
    }
    
    private func settingView() {
        view.backgroundColor = .colorForView()
        stateView.backgroundColor = .getColorFromDeadlineState(event.deadlineState)
    }
    
    private func setupTargets() {
        readyButton.addTarget(self, action: #selector(readyAction), for: .touchUpInside)
        closeVCButton.addTarget(self, action: #selector(closeVCAction), for: .touchUpInside)
    }
}

// MARK: - Action

private extension EventInfoViewController {
    
    @objc
    private func readyAction(_ sender: Any) {
        eventViewModel.updateEventReadiness(event: event)
    }
    
    @objc
    private func closeVCAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension EventInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UsersTableViewCell else { return UITableViewCell() }
        cell.configure(with: event.executorInfo)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.customTableView(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? UsersTableViewCell else { return }
        cell.contentView.backgroundColor = .white
    }
}

