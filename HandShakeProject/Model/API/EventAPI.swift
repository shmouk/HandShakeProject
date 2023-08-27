import Firebase
import FirebaseStorage
import UIKit

class EventAPI {
    static var shared = EventAPI()
    private let database = SetupDatabase().setDatabase()
    private let storage = Storage.storage().reference()
    var events = [Event]()
    
    private init() {}
    
    func writeToDatabase(_ teamId: String, _ eventData: [String : Any], completion: @escaping ResultCompletion) {
        let ref = database.child("events")
        let childRef = ref.childByAutoId()
        guard let eventId = childRef.key else { return }
        childRef.setValue(eventData) { (error, _) in
            if let error = error {
                completion(.failure(error))
            } else {
                self.updateTeamEvents(teamId, eventId) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                        
                    case .success():
                        let text = "Success added to database"
                        completion(.success(text))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func updateTeamEvents(_ teamId: String, _ eventID: String, completion: @escaping VoidCompletion) {
        let ref = database.child("teams").child(teamId).child("eventID")
        let eventData: [String: Int] = [
            eventID: Int(Date().timeIntervalSince1970)
        ]
        
        ref.updateChildValues(eventData) { (error, _) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func convertIdToUserName(_ ids: [String], completion: @escaping ([String]) -> Void) {
        let users = UserAPI.shared.users
        DispatchQueue.global().async { [weak self] in
            guard self != nil else { return }
            
            var userNames: [String] = []
            
            for id in ids {
                if let userName = users.first(where: { $0.uid == id })?.name {
                    userNames.append(userName)
                }
            }
            
            DispatchQueue.main.async {
                completion(userNames)
            }
        }
    }
}

