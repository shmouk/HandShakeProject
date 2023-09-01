func observeMessages(completion: @escaping VoidCompletion) {
    guard let uid = User.fetchCurrentId() else { return }
    
    let userMessagesRef = SetupDatabase.setDatabase().child("user-messages").child(uid)
    
    let dispatchGroup = DispatchGroup()
    var messages = [Message]()
    DispatchQueue.global(qos: .userInteractive).async { [self] in
        let observer = userMessagesRef.observe(.childAdded, with: { [weak self] (snapshot) in
            guard let self = self else { return }
            dispatchGroup.enter()
            let messageId = snapshot.key
            let messagesReference = SetupDatabase.setDatabase().child("messages").child(messageId)
            dispatchGroup.enter()
            messagesReference.observeSingleEvent(of: .value) { [weak self] (snapshot) in
                guard let self = self else { return }
                
                fetchMessageFromUser(snapshot, uid) { (result) in
                    
                    switch result {
                    case .success(let message):
                        DispatchQueue.main.async {
                            messages.append(message)
                            print(1, message.text)
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                    dispatchGroup.leave()
                }
                dispatchGroup.leave()
                
            }
            
        })
        
        observerUIntData = [observer]
    }
    dispatchGroup.notify(queue: .main) {
        print(233223, messages)
        self.allMessages = messages
        completion(.success(()))
    }
}
