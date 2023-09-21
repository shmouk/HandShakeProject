import UIKit

final class APIManager {
    static func clearSingletonData(completion: @escaping () -> Void) {
        UserAPI.shared.removeData()
        ChatAPI.shared.removeData()
        TeamAPI.shared.removeData()
        EventAPI.shared.removeData()
        completion()
    }
    
    private static func pullNotification() {
        NotificationCenterManager.shared.postCustomNotification(named: .addProgressNotification)
    }
    
    static func loadSingletonData(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        UserAPI.shared.observeUsers { observeUsersResult in
            switch observeUsersResult {
            case .success:
                print("Users observed successfully")
                pullNotification()
            case .failure(let error):
                print("Failed to observe users: \(error.localizedDescription)")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                observeMessagesAndComplete { }
                observeTeamAndComplete {
                    observeEventAndComplete(completion)
                }
            }
        }
    }
    
    private static func observeMessagesAndComplete(_ completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        ChatAPI.shared.observeMessages { observeMessagesResult in
            switch observeMessagesResult {
            case .success:
                print("Messages observed successfully")
                pullNotification()
            case .failure(let error):
                print("Failed to observe messages: \(error.localizedDescription)")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    private static func observeTeamAndComplete(_ completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        TeamAPI.shared.observeTeams { observeTeamResult in
            switch observeTeamResult {
            case .success:
                print("Teams observed successfully")
                pullNotification()
            case .failure(let error):
                print("Failed to observe teams: \(error.localizedDescription)")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    private static func observeEventAndComplete(_ completion: @escaping () -> Void) {
        
        EventAPI.shared.observeEventsFromTeam { observeTeamResult in
            switch observeTeamResult {
            case .success:
                print("Events observed successfully")
                pullNotification()
                completion()
                
            case .failure(let error):
                print("Failed to observe events: \(error.localizedDescription)")
                completion()
                
            }
        }
    }
}


