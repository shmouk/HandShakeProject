//
//  ChatViewModel.swift
//  HandShakeProject
//
//  Created by Марк on 29.07.23.
//
import FirebaseAuth
import Foundation

class UserChatViewModel {
    let userAPI = UserAPI.shared
    
    var chatAPI = ChatAPI()
    var user = Bindable(User())
    var users: [User]?
    var messages: [Message]?
    
    func fetchUserMessage() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            chatAPI.observeMessages { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let messages):
                    self.messages = messages
                case .failure(_):
                    break
                }
            }
        }
    }
    
    func fetchUsers() {
        users = userAPI.users
        print("i did it\(users)")
    }
    
    func fetchUserFromMessage(_ index: Int) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let messages = self.messages else { return }
            
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



