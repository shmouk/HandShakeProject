import FirebaseAuth
import Foundation

class UserChatViewModel {
    let userAPI = UserAPI.shared
    let chatAPI = ChatAPI.shared
    
    var user = Bindable(User())
    var users = Bindable([User()])
    var messages = Bindable([Message()])
    
    init() {
        print("hi im UserChatViewModel")
    }
    
    func loadMessages() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.messages.value = self.chatAPI.messages
        }
    }
    
    func loadUsers() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.users.value = self.userAPI.users
        }
    }


    
    func fetchUserFromMessage(_ index: Int) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let messages = self.messages.value
            
            self.userAPI.loadUserChat(index, messages: messages) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let user):
                    self.user.value = user
                case .failure:
                    break
                }
            }
        }
    }
}



