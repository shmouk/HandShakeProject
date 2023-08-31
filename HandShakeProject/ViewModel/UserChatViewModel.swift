import FirebaseAuth
import Foundation

class UserChatViewModel {
    private let chatAPI = ChatAPI.shared
    private let userAPI = UserAPI.shared
    private let userDefaults = UserDefaultsManager.shared
    private var withUser: User?
    
    var lastMessageArray = Bindable([Message()])
    var filterMessages = Bindable([Message()])
    
    var fetchUser = Bindable(User())
    var users = Bindable([User()])
        
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateMessages), name: ChatAPI.messageUpdateNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setChattingUser(_ user: User) {
        self.withUser = user
    }
    
    func loadUsers() {
        DispatchQueue.main.async { [self] in
            users.value = userAPI.users
        }
    }
    
    func loadLastMessagePerUser() {
        chatAPI.filterLastMessagePerUser { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let messages):
                self.lastMessageArray.value = messages
                userDefaults.saveValue(messages.count, forKey: "messagesCount")
                
            case .failure(_):
                break
            }
        }
    }
    
    func loadMessagesPerUser() {
        guard let withUser = self.withUser else {
            return
        }
        chatAPI.filterMessagesPerUser(withUser) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let messages):
                self.filterMessages.value = messages
            case .failure(_):
                break
            }
        }
    }
    
    func fetchUserFromMessage(_ index: Int, completion: @escaping VoidCompletion) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let messages = self.lastMessageArray.value
            self.userAPI.fetchUserFromChat(index, messages: messages) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let user):
                    self.fetchUser.value = user
                    completion(.success(()))
                    
                case .failure(let error):
                    completion(.failure(error))
                    break
                }
            }
        }
    }
    
    func sendMessage(text: String, toId: String) {
        chatAPI.sendMessage(text: text, toId: toId) { _ in
        }
    }
    
    func loadMessagesIntoUserDefaults() -> Int {
        guard let count: Int = userDefaults.getValue(forKey: "messagesCount") else { return 0 }
        return count
    }
}

extension UserChatViewModel {
    @objc
    private func updateMessages() {
        loadLastMessagePerUser()
        loadMessagesPerUser()
//        print("new message")
    }
}
