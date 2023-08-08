import Firebase
import FirebaseStorage
import UIKit

class ChatAPI {
    let database: DatabaseReference
    let storage: StorageReference
    
    var messages = [Message]()
    var messagesTEST = [Message]()
    var messagesDictionaryTEST = [String : [Message]]()
    var messagesDictionary = [String : Message]()
    
    static var shared = ChatAPI()
    
    typealias UserCompletion = (Result<(UIImage, String), Error>) -> Void
    
    private init() {
        database = SetupDatabase().setDatabase()
        storage = Storage.storage().reference()
    }
    
    deinit {
        print("deinit ChatAPI")
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
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func loadUserMessages(_ index: Int, messages: [Message], completion: @escaping (Result<Message, Error>) -> Void) {
            guard let uid = Auth.auth().currentUser?.uid else {
                completion(.failure(NSError(domain: "Current user is not authenticated", code: 401, userInfo: nil)))
                return
            }
            guard messages.indices.contains(index) else {
                completion(.failure(NSError(domain: "Invalid index", code: 400, userInfo: nil)))
                return
            }
            
//            completion(.success(user)) 
        }
    
    func observeMessages(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            let error = NSError(domain: "Current user is not authenticated", code: 401, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        let userMessagesRef = database.child("user-messages").child(uid)
        
        userMessagesRef.observe(.childAdded) { [weak self] (snapshot) in
            guard let self = self else { return }
            let messageId = snapshot.key
            let messagesReference = self.database.child("messages").child(messageId)
            
            messagesReference.observeSingleEvent(of: .value) { [weak self] (snapshot) in
                guard let self = self else { return }
                guard let dict = snapshot.value as? [String: Any],
                      let fromId = dict["fromId"] as? String,
                      let toId = dict["toId"] as? String,
                      let timestamp = dict["timestamp"] as? Int,
                      let text = dict["text"] as? String else {
                    return
                }
                var withId = fromId == uid ? toId : fromId

                fetchUser(userId: withId) { [weak self] (result) in
                    guard let self = self else { return }
                    switch result {
                    case .success(let (image, name)):
                        DispatchQueue.main.async {
                            let message = Message(fromId: fromId, toId: toId, name: name, timeStamp: timestamp, text: text, image: image)
                            if uid == withId {
                                withId = toId
                            }

                            self.messagesDictionary[withId] = message
                            
                            self.messagesTEST.append(message)
                            self.messagesDictionaryTEST[withId] = self.messagesTEST
                            
                            print("\(self.messagesTEST.count), \(self.messagesTEST)")
                            
                            self.messages = Array(self.messagesDictionary.values)
                            
                            completion(.success(()))
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            }
        }
    }

    
    func sendMessage(text: String, toId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let fromId = Auth.auth().currentUser?.uid else {
            let error = NSError(domain: "Current user is not authenticated", code: 401, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        let ref = database.child("messages")
        let childRef = ref.childByAutoId()
        let timestamp = Int(Date().timeIntervalSince1970)
        let values = ["fromId": fromId, "toId": toId, "timestamp": timestamp, "text": text] as [String : Any]
        childRef.updateChildValues(values) { (error, ref) in
            if let error = error {
                completion(.failure(error))
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

