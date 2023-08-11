import FirebaseAuth
import Foundation

class UserChatViewModel {
    let userAPI = UserAPI.shared
    let chatAPI = ChatAPI.shared
    
    var lastMessageArray: Bindable<[Message]> = Bindable([])
    var newMessageReceived: Bindable<[Message]> = Bindable([]) 
    var filterMessages: Bindable<[Message]> = Bindable([])
    
    var fetchUser: Bindable<User> = Bindable(User())
    var users: Bindable<[User]> = Bindable([])
    
    static var currentUID = UserAPI.shared.currentUID
    
    init() {
    }
    
    func loadMessages() {
        lastMessageArray.value = chatAPI.lastMessageFromMessages
        newMessageReceived.value = chatAPI.allMessages
        print("messages:", lastMessageArray.value.count, newMessageReceived.value.count)
    }
    
    func loadUsers() {
        users.value = userAPI.users
        print("users:", users.value.count)
    }
    
    func loadMessagesPerUser(_ user: User) {
        chatAPI.filterMessagesPerUser(user) {[weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let messages):
                self.filterMessages.value = messages
            case .failure(_):
                break
            }
        }
    }
    
    func fetchUserFromMessage(_ index: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let messages = self.chatAPI.lastMessageFromMessages
            self.userAPI.loadUserChat(index, messages: messages) { [weak self] result in
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
}




