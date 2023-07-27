import Firebase
import FirebaseStorage
import UIKit

class ChatAPI {
    let database: DatabaseReference
    let storage: StorageReference
    
    var users = [User]()
    
    init() {
        self.database = SetupDatabase().setDatabase()
        self.storage = Storage.storage().reference()
    }
    
    func sendMessage(text: String) {
        let ref = database.child("messages")
        let childRef = ref.childByAutoId()
        
        let values = ["text": text]
        childRef.updateChildValues(values)
    }
}
