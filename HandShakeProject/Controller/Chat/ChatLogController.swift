import Foundation
import UIKit


class ChatLogController: UIViewController {
    private let interfaceBuilder = InterfaceBuilder()
    private let chatViewModel = ChatViewModel()
    
    private let cellId = "MessageCollectionViewCell"
    
    lazy var containerView = interfaceBuilder.createView()
    lazy var sendButton = interfaceBuilder.createButton()
    lazy var textField = interfaceBuilder.createTextField()
    lazy var collectionView = interfaceBuilder.createCollectionView()
    
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
        settingsCollectionView()
    }
    
    private func setSubviews() {
        keyboardManager = KeyboardNotificationManager(view: view)
        tabBarController?.tabBar.isHidden = true
        containerView.addSubviews(textField, sendButton)
        view.addSubview(containerView)
        view.addSubview(collectionView)
        view.backgroundColor = .colorForView()
    }
    
    private func settingsCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MessageCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
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
        self.collectionView.reloadData()
        
        if let indexPath = self.getLastIndexPath() {
            collectionView.reloadItems(at: [indexPath])
            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    private func getLastIndexPath() -> IndexPath? {
        guard self.messages != nil else {
            return nil
        }
        
        let lastSection = collectionView.numberOfSections - 1
        if lastSection < 0 {
            return nil
        }
        
        let lastItem = collectionView.numberOfItems(inSection: lastSection) - 1
        if lastItem < 0 {
            return nil
        }
        
        return IndexPath(item: lastItem, section: lastSection)
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

extension ChatLogController: UICollectionViewDataSource {
}

extension ChatLogController: UICollectionViewDelegateFlowLayout {
    
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        messages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MessageCollectionViewCell,
            let message = messages?[indexPath.item] else {
            return UICollectionViewCell() }
        let cellSize = message.text.calculateLabelSize(for: message.text, width: (collectionView.bounds.width * 2/3))
        cell.cellSize = cellSize
        cell.partnerUID = user.uid
        cell.configure(with: message)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MessageCollectionViewCell,
            let message = messages?[indexPath.item] else {
            return .zero }
        let width = collectionView.frame.width
        let cellSize = message.text.calculateLabelSize(for: message.text, width: (collectionView.bounds.width * 2/3))
        return CGSize(width: width, height: cellSize.height)
    }
}

