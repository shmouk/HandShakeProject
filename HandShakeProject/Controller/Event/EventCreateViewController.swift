//
//  EventCreateViewController.swift
//  HandShakeProject
//
//  Created by Марк on 19.07.23.
//

import UIKit

class EventCreateViewController: UIViewController {
    
    private let interfaceBuilder = InterfaceBuilder()
    private let eventViewModel = EventViewModel()
    private let userChatViewModel = UserChatViewModel()
    private let deadlineState = ["No time", "Low", "Medium", "High"]
    
    lazy var namingTextField = interfaceBuilder.createTextField()
    lazy var descriptionTextView = interfaceBuilder.createTextView()
    lazy var readingListTextView = interfaceBuilder.createTextView()
    
    lazy var teamTitleLabel = interfaceBuilder.createTitleLabel()
    lazy var pickedTeamLabel = interfaceBuilder.createTitleLabel()
    lazy var nameTitleLabel = interfaceBuilder.createTitleLabel()
    lazy var deadlineTypeTitleLabel = interfaceBuilder.createTitleLabel()
    lazy var dateTitleLabel = interfaceBuilder.createTitleLabel()
    lazy var descriptionTitleLabel = interfaceBuilder.createTitleLabel()
    lazy var executorTitleLabel = interfaceBuilder.createTitleLabel()
    lazy var pickedExecutorLabel = interfaceBuilder.createTitleLabel()
    lazy var readerTitleLabel = interfaceBuilder.createTitleLabel()
    
    lazy var chooseTeamButton = interfaceBuilder.createButton()
    lazy var chooseExecutorButton = interfaceBuilder.createButton()
    lazy var shooseReaderButton = interfaceBuilder.createButton()
    
    lazy var importanceSegmentControl = interfaceBuilder.createSegmentControl(items: deadlineState)
    lazy var datePicker = interfaceBuilder.createDatePicker()
    
    private var keyboardManager: KeyboardNotificationManager?
    
    private var selectedTeam: Team? {
        didSet {
            pickedTeamLabel.text = selectedTeam?.teamName
            readingListTextView.text = selectedTeam?.userList?.joined(separator: ", ")
        }
    }
    
    private var selectedDate: Date?
    private var selectedState: Int?
    private var selectedExecutorUser: User? {
        didSet {
            pickedExecutorLabel.text = selectedExecutorUser?.name
        }
    }
    private var selectedReaderUsers: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadDataIfNeeded()
    }
    
    private func bindViewModel() {
        eventViewModel.currentTeam.bind { [weak self] team in
            guard let self = self, let team = team.first else { return }
            self.selectedTeam = team
        }
    }
    
    private func reloadDataIfNeeded() {
        if selectedTeam == nil {
            eventViewModel.fetchCurrentTeam { [weak self] error in
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
        keyboardManager = KeyboardNotificationManager(view: view)
        view.addSubviews(namingTextField, pickedTeamLabel, datePicker, chooseTeamButton, chooseExecutorButton, descriptionTextView, teamTitleLabel, nameTitleLabel,
                         deadlineTypeTitleLabel, dateTitleLabel, descriptionTitleLabel, executorTitleLabel, pickedExecutorLabel, readerTitleLabel,
                         readingListTextView, shooseReaderButton, importanceSegmentControl)
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
        readingListTextView.isEditable = false
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
        readerTitleLabel.text = "Choose reader:"
    }
    
    private func settingButton() {
        shooseReaderButton.setImage(UIImage(systemName: "person.badge.plus"), for: .normal)
        chooseTeamButton.setImage(UIImage(systemName: "person.3"), for: .normal)
        chooseExecutorButton.setImage(UIImage(systemName: "person.badge.plus"), for: .normal)
        
        [shooseReaderButton, chooseTeamButton, chooseExecutorButton].forEach({ $0.tintColor = .colorForTitleText()})
    }
    
    private func setLabelAppearance() {
        [pickedTeamLabel, pickedExecutorLabel].forEach({ $0.textAlignment = .center })
        [pickedTeamLabel, pickedExecutorLabel].forEach({ $0.backgroundColor = .colorForView() })
        //        [pickedTeamLabel, pickedExecutorLabel].forEach({ $0.textColor = .systemRed })
    }
    
    private func settingViews() {
        view.backgroundColor = .white
    }
    
    private func setupTargets() {
        importanceSegmentControl.addTarget(self, action: #selector(changeDeadlineStateAction(_:)), for: .valueChanged)
        shooseReaderButton.addTarget(self, action: #selector(addReaderAction(_:)), for: .touchUpInside)
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
    
    private func collectDictionary() -> [String : Any]{
        var dict = [String : Any]()
        let readerUserList = selectedTeam?.userList
        
        dict["team"] = selectedTeam?.teamId
        dict["name"] = namingTextField.text
        dict["description"] = descriptionTextView.text
        dict["deadlineState"] = selectedState
        dict["date"] = selectedExecutorUser?.uid
        dict["readerList"] = readerUserList
        return dict
    }
    
    private func showUserListVC() {
        userChatViewModel.loadUsers()
        userChatViewModel.users.bind { [weak self] users in
            guard let self = self else { return }
            let usersListTableViewController = UsersListTableViewController(users: users, isCellBeUsed: true)
            usersListTableViewController.delegate = self
            usersListTableViewController.modalPresentationStyle = .automatic
            present(usersListTableViewController, animated: true)
        }
    }
    private func createEvent() {
        AlertManager.showConfirmationAlert(title: "CreateAlert", message: "Are you sure you want to create an event and it doesn't need to be changed?", viewController: self) { [weak self] in
            guard let self = self else { return }
            eventViewModel.createEvent(collectDictionary()) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let text):
                    dismiss(animated: true)
                    AlertManager.showAlert(title: "Success", message: "You created event", viewController: self)
                    
                case .failure(let error):
                    AlertManager.showAlert(title: "Failure", message: error.localizedDescription, viewController: self)
                }
            }
        }
    }
}

extension EventCreateViewController: UsersListTableViewControllerDelegate {
    func chooseUser(_ user: User) {
        selectedExecutorUser = user
    }
}

// MARK: - Action

private extension EventCreateViewController {
    
    @objc
    private func createEventAction(_ sender: Any) {
        createEvent()
    }
    
    @objc
    private func addExecutorAction(_ sender: Any) {
        showUserListVC()
    }
    
    @objc
    private func addReaderAction(_ sender: Any) {
        showUserListVC()
    }
    
    @objc
    private func changeDeadlineStateAction(_ sender: Any) {
        selectedState = importanceSegmentControl.selectedSegmentIndex
    }
    
    @objc func datePickerAction(_ sender: UIDatePicker) {
        selectedDate = sender.date
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
        guard let currentText = textView.text, let range = Range(range, in: currentText) else { return false }
        let newText = currentText.replacingCharacters(in: range, with: text)
        if newText.count > 100 {
            return false
        }
        if text == "\n" {
            descriptionTextView.resignFirstResponder()
            return false
        }
        return true
    }
}

