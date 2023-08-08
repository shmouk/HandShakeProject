import FirebaseAuth
import Foundation

class UserChatViewModel {
    let userAPI = UserAPI.shared
    let chatAPI = ChatAPI.shared
    
    var user = Bindable(User())
    var users = Bindable([User()])
    var messages = Bindable([Message()])
    var messagesFromUser = Bindable([Message()])
    
    var messagesPerUser = Bindable([Message()])
    
    init() {
        print("hi im UserChatViewModel")
       
    }
    
    func loadData() {
        userAPI.loadUsersFromDatabase { [weak self] _ in
            guard let self = self else { return }
        }
        chatAPI.observeMessages { [weak self] _ in
                guard let self = self else { return }
        }
    }
    
    func loadMessages() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.messages.value = self.chatAPI.messages
        }
    }
    
    func loadMessagesPerUser(_ user: User) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let messagesDict = self.chatAPI.messagesDictionaryTEST
            let uid = user.uid
            
            guard let messages = messagesDict[uid] else { return }
            messagesPerUser.value = messages

        }
    }
    
    func loadUsers() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.users.value = self.userAPI.users
        }
    }
    
    func fetchUserFromMessage(_ index: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let messages = self.chatAPI.messages
            self.userAPI.loadUserChat(index, messages: messages) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let user):
                    self.user.value = user
                    completion(.success(()))
                    
                case .failure(let error):
                    completion(.failure(error))
                    break
                }
            }
        }
    }
}



