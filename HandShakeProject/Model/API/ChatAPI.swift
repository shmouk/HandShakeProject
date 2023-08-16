import Firebase
import FirebaseStorage
import UIKit

class ChatAPI{
    private let database: DatabaseReference
    private let storage: StorageReference
    
    var lastMessageFromMessages = [Message]()
    var allMessages = [Message]()
    var currentUID: String?

    static var shared = ChatAPI()
    
    typealias UserCompletion = (Result<(UIImage, String), Error>) -> Void
    
    private init() {
        database = SetupDatabase().setDatabase()
        storage = Storage.storage().reference()
        fetchCurrentId()
        observeMessages{ _ in
            print("load messages")
        }
    }

    private func fetchCurrentId() {
        currentUID = User.fetchCurrentId()
    }
    
    private func fetchUser(userId: String, completion: @escaping UserCompletion) {
        database.child("users").child(userId).observeSingleEvent(of: .value) { snapshot in
            guard let userDict = snapshot.value as? [String: Any],
                  let imageUrlString = userDict["downloadURL"] as? String,
                  let name = userDict["name"] as? String,
                  let imageUrl = URL(string: imageUrlString) else {
                return
            }
            
            self.downloadImage(from: imageUrl) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        completion(.success((image, name)))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "Error user, \(error.localizedDescription)", code: 0, userInfo: nil)))
                    }
                }
            }
        }
    }
    
    func observeMessages(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = currentUID else { return }
        
        let userMessagesRef = database.child("user-messages").child(uid)
        
        let dispatchGroup = DispatchGroup()
        
        userMessagesRef.observe(.childAdded) { [weak self] (snapshot) in
            guard let self = self else { return }
            
            dispatchGroup.enter()
            
            let messageId = snapshot.key
            let messagesReference = self.database.child("messages").child(messageId)
            
            messagesReference.observeSingleEvent(of: .value) { [weak self] (snapshot) in
                guard let self = self else { return }
                
                guard let dict = snapshot.value as? [String: Any] else {
                    dispatchGroup.leave()
                    return
                }
                dispatchGroup.enter()
                fetchMessageFromUser(dict, uid) { [weak self] (result) in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let message):
                        self.allMessages.append(message)
                        dispatchGroup.leave()
                    case .failure(_):
                        dispatchGroup.leave()
                    }
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(.success(()))
        }
    }
    
    private func fetchMessageFromUser(_ dict: [String: Any], _ uid: String, completion: @escaping (Result<Message, Error>) -> Void) {
        guard let fromId = dict["fromId"] as? String,
              let toId = dict["toId"] as? String,
              let timestamp = dict["timestamp"] as? Int,
              let text = dict["text"] as? String else {
            return
        }
        let withId = fromId == uid ? toId : fromId
        
        self.fetchUser(userId: withId) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let (image, name)):
                let message = Message(fromId: fromId, toId: toId, name: name, timestamp: timestamp, text: text, image: image)
                DispatchQueue.main.async {
                    completion(.success((message)))
                }
            case .failure(let error):
                completion(.failure(NSError(domain: "No message found \(error)", code: 0, userInfo: nil)))
                
            }
        }
    }
    
    func filterMessagesPerUser(_ user: User, completion: @escaping (Result<[Message], Error>) -> Void) {
        guard let uid = currentUID else { return }
        
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
                    completion(.failure(NSError(domain: "No message found", code: 0, userInfo: nil)))
                }
            }
        }
    }
 
    func filterLastMessagePerUser(completion: @escaping (Result<[Message], Error>) -> Void) {
        guard let uid = currentUID else { return }
        
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

            let filteredMessages = Array(lastMessages.values)
            
            DispatchQueue.main.async {
                if !filteredMessages.isEmpty {
                    completion(.success(filteredMessages))
                } else {
                    completion(.failure(NSError(domain: "No message found", code: 0, userInfo: nil)))
                }
            }
        }
    }
    
    func sendMessage(text: String, toId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let fromId = currentUID else { return }

        let ref = database.child("messages")
        let childRef = ref.childByAutoId()
        let timestamp = Int(Date().timeIntervalSince1970)
        let data = ["fromId": fromId, "toId": toId, "timestamp": timestamp, "text": text] as [String : Any]
        childRef.updateChildValues(data) { (error, _) in
            if let error = error {
                completion(.failure(NSError(domain: "Message does not send, \(error)", code: 0, userInfo: nil)))
            } else {
                guard let messageId = childRef.key else { return }
                
                let userMessageRef = self.database.child("user-messages").child(fromId)
                userMessageRef.updateChildValues([messageId: 1])
                
                let recipientUserMessageRef = self.database.child("user-messages").child(toId)
                recipientUserMessageRef.updateChildValues([messageId: 1])
                
                completion(.success(()))
            }
        }
    }
    
    private func downloadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error ?? NSError(domain: "Error downloading image", code: 500, userInfo: nil)))
                }
                return
            }
            
            guard let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Invalid image data", code: 400, userInfo: nil)))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }.resume()
    }
}


