import Firebase
import FirebaseStorage
import UIKit

class EventAPI {
    private let database: DatabaseReference
    private let storage: StorageReference
    
    var currentUID = User.fetchCurrentId()
    var teams = [Event]()
    
    static var shared = EventAPI()
    
    private init() {
        database = SetupDatabase().setDatabase()
        storage = Storage.storage().reference()
    }
    
    func writeToDatabase(_ eventData: [String : Any], completion: @escaping ResultCompletion) {
//        let ref = database.child("events")
//        let childRef = ref.childByAutoId()
//
//        guard let teamId = childRef.key, let uid = User.fetchCurrentId() else { return }
//
//
//
//        childRef.setValue(eventData) { (error, _) in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(()))
//            }
//        }
//
//        let userTeamRef = self.database.child("user-team").child(uid)
//        userTeamRef.updateChildValues([teamId: 1])
//
//    case .failure(let error):
//        completion(.failure(NSError(domain: "No teams found \(error.localizedDescription)", code: 0, userInfo: nil)))
    }
}
 
