import FirebaseAuth
import Foundation

class UserChatViewModel {
    private let chatAPI = ChatAPI.shared
    private let userAPI = UserAPI.shared

    
    var lastMessageArray = Bindable([Message()])
    var filterMessages = Bindable([Message()])
    
    var fetchUser = Bindable(User())
    var users = Bindable([User()])
    
    static var currentUID = UserAPI.shared.currentUID
    
    func loadLastMessagePerUser() {
        chatAPI.filterLastMessagePerUser { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let messages):
                self.lastMessageArray.value = messages
                print(messages)
            case .failure(_):
                break
            }
        }
    }
    
    func loadUsers() {
        DispatchQueue.main.async { [self] in
            users.value = userAPI.users
        }
    }
    
    func loadMessagesPerUser(_ user: User) {
        chatAPI.filterMessagesPerUser(user) { [weak self] result in
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
}





