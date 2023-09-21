import UIKit

class EventCreateViewController: UIViewController {
    lazy var eventViewModel = EventViewModel()
    private let deadlineState = ["No time", "Low", "Medium", "High"]
    
    var namingTextField = InterfaceBuilder.createTextField()
    var descriptionTextView = InterfaceBuilder.createTextView()
    var readingListTextView = InterfaceBuilder.createTextView()
    
    var teamTitleLabel = InterfaceBuilder.createTitleLabel()
    var pickedTeamLabel = InterfaceBuilder.createTitleLabel()
    var nameTitleLabel = InterfaceBuilder.createTitleLabel()
    var deadlineTypeTitleLabel = InterfaceBuilder.createTitleLabel()
    var dateTitleLabel = InterfaceBuilder.createTitleLabel()
    var descriptionTitleLabel = InterfaceBuilder.createTitleLabel()
    var executorTitleLabel = InterfaceBuilder.createTitleLabel()
    var pickedExecutorLabel = InterfaceBuilder.createTitleLabel()
    var readerTitleLabel = InterfaceBuilder.createTitleLabel()
    
    var chooseTeamButton = InterfaceBuilder.createButton()
    var chooseExecutorButton = InterfaceBuilder.createButton()
    
    lazy var importanceSegmentControl = InterfaceBuilder.createSegmentControl(items: deadlineState)
    var datePicker = InterfaceBuilder.createDatePicker()
    
    private var selectedTeam: Team?
    private var selectedDate: Int?
    private var selectedStateIndex: Int?
    private var selectedExecutorUser: User?
    private var selectedReaderUsers: [String]?
    private var teamUsers: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        KeyboardNotificationManager.hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadDataIfNeeded()
    }
    
    private func bindViewModel() {
        eventViewModel.currentTeam.bind { [weak self] team in
            guard let self = self else { return }
            selectedTeam = team
            pickedTeamLabel.text = team.teamName
            selectedReaderUsers = team.userList
        }
        eventViewModel.userNames.bind { [weak self] names in
            guard let self = self else { return }
            readingListTextView.text = names.joined(separator: ", ")
        }
        
        eventViewModel.fetchUsersFromSelectedTeam.bind {[weak self] users in
            guard let self = self else { return }
            teamUsers = users
        }
    }
    
    private func reloadDataIfNeeded() {
        if selectedTeam == nil {
            eventViewModel.fetchTeams { [weak self] error in
                guard let self = self else { return }
                AlertManager.showAlert(title: "Failure", message: error, viewController: self)
            }
        }
    }
    
    private func setUI() {
        setSubviews()
        setSettings()
        setupConstraints()
        setupTargets()
        updateNavItem()
    }
    
    private func setSubviews() {
        view.addSubviews(namingTextField, pickedTeamLabel, datePicker, chooseTeamButton, chooseExecutorButton, descriptionTextView, teamTitleLabel, nameTitleLabel,
                         deadlineTypeTitleLabel, dateTitleLabel, descriptionTitleLabel, executorTitleLabel, pickedExecutorLabel, readerTitleLabel,
                         readingListTextView, importanceSegmentControl)
    }
    
    private func setSettings() {
        settingViews()
        settingTextField()
        settingButton()
        settingTextLabel()
        setLabelAppearance()
    }
    
    private func settingTextField() {
        namingTextField.delegate = self
        descriptionTextView.delegate = self
        descriptionTextView.textContainer.maximumNumberOfLines = 4
        descriptionTextView.textContainer.lineBreakMode = .byTruncatingTail
        readingListTextView.isEditable = false
        descriptionTextView.isEditable = true
        descriptionTextView.returnKeyType = .done
        namingTextField.returnKeyType = .done
        namingTextField.placeholder = "Input name event"
    }
    
    private func settingTextLabel() {
        teamTitleLabel.text = "Choose team:"
        pickedTeamLabel.text = "Unselected"
        nameTitleLabel.text = "Name event:"
        deadlineTypeTitleLabel.text = "Choose deadline type:"
        dateTitleLabel.text = "Choose date:"
        descriptionTitleLabel.text = "Description:"
        executorTitleLabel.text = "Choose executor:"
        pickedExecutorLabel.text = "Unselected"
        readerTitleLabel.text = "Reader:"
    }
    
    private func settingButton() {
        chooseTeamButton.setImage(UIImage(systemName: "person.3"), for: .normal)
        chooseExecutorButton.setImage(UIImage(systemName: "person.badge.plus"), for: .normal)
        [chooseTeamButton, chooseExecutorButton].forEach({ $0.tintColor = .colorForTitleText()})
    }
    
    private func setLabelAppearance() {
        [pickedTeamLabel, pickedExecutorLabel].forEach({ $0.textAlignment = .center })
        [pickedTeamLabel, pickedExecutorLabel].forEach({ $0.backgroundColor = .white })
    }
    
    private func settingViews() {
        view.backgroundColor = .colorForView()
    }
    
    private func setupTargets() {
        chooseTeamButton.addTarget(self, action: #selector(changeTeamAction(_:)), for: .touchUpInside)
        importanceSegmentControl.addTarget(self, action: #selector(changeDeadlineStateAction(_:)), for: .valueChanged)
        datePicker.addTarget(self, action: #selector(datePickerAction(_:)), for: .valueChanged)
        chooseExecutorButton.addTarget(self, action: #selector(addExecutorAction(_:)), for: .touchUpInside)
    }
    
    private func updateNavItem() {
        let navItem = UINavigationItem(title: "Create event")
        let rightButton = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createEventAction))
        navItem.rightBarButtonItem = rightButton
        navigationItem.setRightBarButton(rightButton, animated: false)
        navigationItem.title = navItem.title
        tabBarController?.tabBar.isHidden = true
    }
    
    private func showUserListVC() {
        let usersListTableViewController = UsersListTableViewController(users: teamUsers, isCellBeUsed: true)
        usersListTableViewController.delegate = self
        usersListTableViewController.modalPresentationStyle = .automatic
        present(usersListTableViewController, animated: true)
    }
    
    
    private func createEvent() {
        AlertManager.showConfirmationAlert(title: "Create Alert", message: "Are you sure you want to create an event and it doesn't need to be changed?", viewController: self) { [weak self] in
            guard let self = self else { return }
            eventViewModel.createEvent(nameText: namingTextField.text, descriptionText: descriptionTextView.text, selectedState: selectedStateIndex, selectedDate: selectedDate, selectedExecutorUser: selectedExecutorUser?.uid) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let text):
                    AlertManager.showAlert(title: "Success", message: text, viewController: self)
                    
                case .failure(let error):
                    AlertManager.showAlert(title: "Failure", message: error.localizedDescription, viewController: self)
                }
            }
        }
    }
}

extension EventCreateViewController: UsersListTableViewControllerDelegate {
    func openChatWithChosenUser(_ user: User) {
        selectedExecutorUser = user
        pickedExecutorLabel.text = user.name
    }
}

// MARK: - Action

private extension EventCreateViewController {
    @objc
    private func changeTeamAction(_ sender: Any) {
        AlertManager.showAlert(title: "Warning", message: "Your team is selected automatically, selecting your other teams is not available", viewController: self)
    }
    
    @objc
    private func createEventAction(_ sender: Any) {
        createEvent()
    }
    
    @objc
    private func addExecutorAction(_ sender: Any) {
        showUserListVC()
    }
    
    @objc
    private func changeDeadlineStateAction(_ sender: Any) {
        selectedStateIndex = importanceSegmentControl.selectedSegmentIndex
    }
    
    @objc func datePickerAction(_ sender: UIDatePicker) {
        selectedDate = Int(sender.date.timeIntervalSince1970)
    }
}

extension EventCreateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        namingTextField.resignFirstResponder()
        return true
    }
}

extension EventCreateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        descriptionTextView.text = nil
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            descriptionTextView.resignFirstResponder()
            return false
        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 130
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = namingTextField.text else { return true }
        
        let newLength = text.count + string.count - range.length
        
        return newLength <= 12
    }
}

