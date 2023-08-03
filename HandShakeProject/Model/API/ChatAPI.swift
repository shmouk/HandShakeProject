import Firebase
import FirebaseStorage

class ChatAPI {
    let database: DatabaseReference
    let storage: StorageReference
    
    var messages: [Message] = []
    
    init() {
        self.database = SetupDatabase().setDatabase()
        self.storage = Storage.storage().reference()
    }
    
    func observerMessage() {
        database.child("messages").observe(.childAdded) { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                let uid = data["fromId"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let text = data["text"] as? String ?? ""
                
                let message = Message(uid: uid, name: name, text: text)
                self.messages.append(message)
            }
        }
    }
    
    
    func sendMessage(text: String, toId: String) {
        guard let fromId = Auth.auth().currentUser?.uid else {
            let error = NSError(domain: "Current user is not authenticated", code: 401, userInfo: nil)
            return
        }
        
        let ref = database.child("messages")
        let childRef = ref.childByAutoId()
        
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let values = ["fromId": fromId, "toId": toId, "date": timestamp, "text": text] as [String : Any]
        childRef.updateChildValues(values)
    }
}
