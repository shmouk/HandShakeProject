import Firebase
import UIKit

class ChatAPI: APIClient {
    static let shared = ChatAPI()
    lazy var userAPI = UserAPI.shared
    private let userDefaults = UserDefaultsManager.shared
    var lastMessageFromMessages = [Message]()
    var allMessages = [Message]() {
        didSet {
            if !oldValue.isEmpty {
                notificationCenterManager.postCustomNotification(named: .messageNotification)
            }
        }
    }

    var databaseReferenceData: [DatabaseReference]?
    
    private init() {}
    
    func removeData() {
        removeObserver()
        lastMessageFromMessages = removeData(data: &lastMessageFromMessages)
        allMessages = removeData(data: &allMessages)
    }
    
    func observeMessages(completion: @escaping VoidCompletion) {
        guard let uid = User.fetchCurrentId() else { return }
        
        let userMessagesRef = SetupDatabase.setDatabase().child("user-messages").child(uid)
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            let dispatchGroup = DispatchGroup()
            var messages = [Message]()
            
            userMessagesRef.observeSingleEvent(of: .value) { (snapshot) in
                guard let messagesSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                    completion(.success(()))
                    return
                }
                dispatchGroup.enter()
                DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                    guard let self = self else  {
                        dispatchGroup.leave()
                        return
                    }
                    
                    for messageSnapshot in messagesSnapshot {
                        let messageId = messageSnapshot.key
                        dispatchGroup.enter()
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else {
                                dispatchGroup.leave()
                                return
                            }
                            self.observeMessageInRef(messageId: messageId) { result in
                                switch result {
                                case .success(let message):
                                    messages.append(message)
                                    dispatchGroup.leave()
                                    
                                case .failure(let error):
                                    completion(.failure(error))
                                    dispatchGroup.leave()
                                    
                                }
                            }
                        }
                    }
                    dispatchGroup.leave()
                }
                dispatchGroup.notify(queue: .main) { [weak self] in
                    guard let self = self else {
                        completion(.success(()))
                        return
                    }
                    startObserveNewData(ref: userMessagesRef)
                    self.allMessages = messages
                    self.allMessages.sort { $0.timestamp < $1.timestamp}
                    completion(.success(()))
                }
            }
        }
    }
    
    func observeMessageInRef(messageId: String, completion: @escaping MessageCompletion) {
        let messagesReference = SetupDatabase.setDatabase().child("messages").child(messageId)
        
        messagesReference.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let self = self else { return }
            self.fetchMessageFromUser(snapshot) { (result) in
                switch result {
                case .success(let message):
                        completion(.success(message))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func startObserveNewData(ref: DatabaseReference) {
        databaseReferenceData = [ref]
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }

            ref.observe(.childAdded) { [weak self] (snapshot) in
                guard let self = self else { return }
                let messageId = snapshot.key
                
                self.observeMessageInRef(messageId: messageId) { [weak self] result in
                    guard let self = self else { return }

                    switch result {
                    case .success(let message):
                        let alreadyAdded = self.allMessages.contains { $0.messageId == messageId }

                        if !alreadyAdded {
                            if message.toId == User.fetchCurrentId() {
                                userNotificationsManager.scheduleNotification(withTitle: "You received a notification", body: message.name + ": " + message.text)
                            }
                            self.allMessages.append(message)
                            self.allMessages.sort { $0.timestamp < $1.timestamp}
                        }
                
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func fetchUserFromChat(_ index: Int, messages: [Message], completion: @escaping UserCompletion) {
        guard let uid = User.fetchCurrentId() else { return }
        guard messages.indices.contains(index) else {
            completion(.failure(NSError(domain: "Invalid index", code: 400, userInfo: nil)))
            return
        }
        let message = messages[index]
        let chatUserId = uid == message.toId ? message.fromId : message.toId
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            guard let user = self.userAPI.users.first(where: { $0.uid == chatUserId }) else {
                completion(.failure(NSError(domain: "User not found", code: 404, userInfo: nil)))
                return
            }
            DispatchQueue.main.async {
                completion(.success(user))
            }
        }
    }
    
    private func fetchMessageFromUser(_ snapshot: DataSnapshot, completion: @escaping MessageCompletion) {
        guard let  dict = snapshot.value as? [String: Any],
              let fromId = dict["fromId"] as? String,
              let toId = dict["toId"] as? String,
              let timestamp = dict["timestamp"] as? Int,
              let text = dict["text"] as? String,
              let uid = User.fetchCurrentId() else {
            return
        }
        let withId = fromId == uid ? toId : fromId
        let messageId = snapshot.key
        
        userAPI.fetchUser(uid: withId) { [weak self] (result) in
            guard self != nil else { return }
            
            switch result {
            case .success(let user):
                let message = Message(messageId: messageId, fromId: fromId, toId: toId, name: user.name, timestamp: timestamp, text: text, image: user.image)
                DispatchQueue.main.async {
                    completion(.success((message)))
                }
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }
    
    func filterMessagesPerUser(_ user: User, completion: @escaping MessagesCompletion) {
        guard let uid = User.fetchCurrentId() else { return }
        
        let partnerUserId = user.uid
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let filteredMessages = self.allMessages.filter { message in
                return (message.fromId == uid && message.toId == partnerUserId) || (message.fromId == partnerUserId && message.toId == uid)
            }
            
            let sortedMessages = filteredMessages.sorted { $0.timestamp < $1.timestamp }
            
            DispatchQueue.main.async {
                if !sortedMessages.isEmpty {
                    completion(.success(sortedMessages))
                } else {
                    completion(.failure(NSError(domain: "No message found,", code: 404, userInfo: nil)))
                }
            }
        }
    }
    
    func filterLastMessagePerUser(completion: @escaping (Result<[Message], Error>) -> Void) {
        guard let uid = User.fetchCurrentId() else { return }
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            var lastMessages: [String: Message] = [:]
            
            for message in self.allMessages {
                let partnerUserId = message.fromId == uid ? message.toId : message.fromId
                if let existingMessage = lastMessages[partnerUserId] {
                    if message.timestamp > existingMessage.timestamp {
                        lastMessages[partnerUserId] = message
                    }
                } else {
                    lastMessages[partnerUserId] = message
                }
            }
            
            let sortedMessages = lastMessages.values.sorted { $0.timestamp > $1.timestamp }
            
            DispatchQueue.main.async {
                if !sortedMessages.isEmpty {
                    completion(.success(sortedMessages))
                } else {
                    completion(.failure(NSError(domain: "No message found,", code: 404, userInfo: nil)))
                }
            }
        }
    }
    
    func sendMessage(text: String, toId: String, completion: @escaping VoidCompletion) {
        guard let uid = User.fetchCurrentId() else { return }
        
        let ref = SetupDatabase.setDatabase().child("messages")
        let childRef = ref.childByAutoId()
        let timestamp = Int(Date().timeIntervalSince1970)
        let data = ["fromId": uid, "toId": toId, "timestamp": timestamp, "text": text] as [String : Any]
        DispatchQueue.global(qos: .utility).async {
            childRef.updateChildValues(data) { (error, _) in
                if let error = error {
                    completion(.failure(NSError(domain: "Message does not send, \(error)", code: 500, userInfo: nil)))
                } else {
                    guard let messageId = childRef.key else { return }
                    
                    let userMessageRef = SetupDatabase.setDatabase().child("user-messages").child(uid)
                    userMessageRef.updateChildValues([messageId: 1])
                    
                    let recipientUserMessageRef = SetupDatabase.setDatabase().child("user-messages").child(toId)
                    recipientUserMessageRef.updateChildValues([messageId: 1])
                    
                    completion(.success(()))
                }
            }
        }
    }
}


