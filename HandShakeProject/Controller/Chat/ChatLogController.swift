import Foundation
import UIKit


class ChatLogController: UICollectionViewController {
    
    lazy var containerView = interfaceBuilder.createView()
    lazy var sendButton = interfaceBuilder.createButton()
    lazy var textField = interfaceBuilder.createTextField()
    lazy var separatorView = interfaceBuilder.createView()
    
    let interfaceBuilder = InterfaceBuilder()
    private let userChatViewModel = UserChatViewModel()
    private let cellId = "cellId"
    private var messages: [Message]?
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
        reloadDataIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        messages?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let uid = self.user?.uid, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MessageCollectionViewCell else { return UICollectionViewCell() }
        let message = messages?[indexPath.row]
        cell.partnerUID = uid
        cell.message = message
        return cell
    }
    
    private func setUI() {
        setSubviews()
        setupConstraints()
        settingTextField()
        settingButton()
        setupTargets()
    }
    
    private func setSubviews() {
        tabBarController?.tabBar.isHidden = true
        collectionView.register(MessageCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubviews(containerView)
        view.addSubviews(textField, sendButton)
    }
    
    private func settingTextField() {
        textField.delegate = self
        textField.placeholder = "Input text..."
    }
    
    private func settingButton() {
        sendButton.setTitle("Send", for: .normal)
        
    }
    
    private func loadData() {
        guard let user = self.user else { return }
            self.userChatViewModel.loadMessages()
            self.userChatViewModel.loadMessagesPerUser(user)
    }
    
    private func reloadDataIfNeeded() {
        if messages?.isEmpty ?? true {
            loadData()
        }
    }

    private func bindViewModel() {
        userChatViewModel.newMessageReceived.bind { [weak self] _ in
            guard let self = self else { return }
            userChatViewModel.filterMessages.bind { [weak self] messages in
                guard let self = self else { return }
                self.messages = messages
                self.reloadTable()
            }
        }
    }

    private func sendText() {
        guard let text = textField.text,
              let uid = user?.uid else { return }
        userChatViewModel.sendMessage(text: text, toId: uid)
    }
    
    private func setupTargets() {
        sendButton.addTarget(self, action: #selector(sendAction(_:)), for: .touchUpInside)
    }
       
    private func reloadTable() {
        self.collectionView.reloadData()
        
        if let indexPath = self.getLastIndexPath() {
            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    private func getLastIndexPath() -> IndexPath? {
        guard let messages = self.messages else {
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
    }
}

extension ChatLogController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ChatLogController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height / 14)
    }
}

