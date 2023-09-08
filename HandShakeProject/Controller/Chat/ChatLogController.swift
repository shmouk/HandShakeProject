import Foundation
import UIKit


class ChatLogController: UIViewController {
    private let chatViewModel = ChatViewModel()
    
    private let cellId = "MessageTextTableViewCell"
    
    var containerView = InterfaceBuilder.createView()
    var sendButton = InterfaceBuilder.createButton()
    var textField = InterfaceBuilder.createTextField()
    var tableView = InterfaceBuilder.createTableView()
    
    private var messages: [Message]?
    private var keyboardManager: KeyboardNotificationManager?
    private let user: User

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        KeyboardNotificationManager.hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadDataIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()        
    }

    private func setUI() {
        setSubviews()
        setupConstraints()
        setSettings()
        setupTargets()
    }
    
    private func setSettings() {
        settingTextField()
        settingTextLabel()
        settingButton()
        settingTableView()
    }
    
    private func setSubviews() {
        keyboardManager = KeyboardNotificationManager(view: view)
        tabBarController?.tabBar.isHidden = true
        containerView.addSubviews(textField, sendButton)
        view.addSubview(containerView)
        view.addSubview(tableView)
        view.backgroundColor = .colorForView()
    }
    
    private func settingTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(MessageTextTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    private func settingTextLabel() {
        navigationItem.title = user.name
    }

    private func settingTextField() {
        textField.delegate = self
        textField.placeholder = "Input text..."
    }
    
    private func settingButton() {
        sendButton.setTitle("Send", for: .normal)
        sendButton.layer.masksToBounds = true
    }
    
    private func loadData() {
        chatViewModel.observeChattingUser(user: user)
        chatViewModel.loadMessagesPerUser()
    }
    
    private func reloadDataIfNeeded() {
        if messages?.isEmpty ?? true {
            loadData()
        }
    }
    
    private func bindViewModel() {
        chatViewModel.filterMessages.bind { [weak self] messages in
            guard let self = self else { return }
            self.messages = messages
            self.reloadTable()
        }
    }

    private func sendText() {
        guard let text = textField.text, text != "" else { return }
        chatViewModel.sendMessage(text: text, toId: user.uid )
    }
    
    private func setupTargets() {
        sendButton.addTarget(self, action: #selector(sendAction(_:)), for: .touchUpInside)
    }
       
    private func reloadTable() {
        self.tableView.reloadData()
    }
}

extension ChatLogController {
    @objc
    private func sendAction(_ sender: Any) {
        sendText()
        textField.text = ""
    }
}

extension ChatLogController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ChatLogController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageTextTableViewCell,
              let message = messages?[indexPath.row] else
        { return UITableViewCell() }
        cell.configure(with: message)
        cell.selectionStyle = .none
        return cell
    }
}

