import FirebaseAuth
import Foundation

class ChatViewModel {
    private let chatAPI = ChatAPI.shared
    private let userDefaults = UserDefaultsManager.shared
    private var currentChattingUser: User?
    var lastMessageArray = Bindable([Message()])
    var filterMessages = Bindable([Message()])
    var fetchUser = Bindable(User())
    
    init() {
        chatAPI.notificationCenterManager.addObserver(self, selector: #selector(updateMessages), forNotification: .messageNotification)
    }
    
    deinit {
        chatAPI.notificationCenterManager.removeObserver(self, forNotification: .messageNotification)
    }
    
    func observeChattingUser(user: User) {
        currentChattingUser = user
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
        guard let withUser = self.currentChattingUser else { return }
        chatAPI.filterMessagesPerUser(withUser) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let messages):
                self.filterMessages.value = messages
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchUserFromMessage(_ index: Int, completion: @escaping (User) -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let messages = self.lastMessageArray.value
            self.chatAPI.fetchUserFromChat(index, messages: messages) { result in
                switch result {
                case .success(let user):
                    completion(user)
                    
                case .failure(let error):
                    print(error.localizedDescription)
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

extension ChatViewModel {
    @objc
    private func updateMessages() {
        loadLastMessagePerUser()
        loadMessagesPerUser()
    }
}
