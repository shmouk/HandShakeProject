import UIKit

final class APIManager {
    static func clearSingletonData(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            UserAPI.shared.removeData()
            ChatAPI.shared.removeData()
            TeamAPI.shared.removeData()
            EventAPI.shared.removeData()
            completion()
        }
    }
    
    static func loadSingletonData(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        UserAPI.shared.observeUsers { observeUsersResult in
            switch observeUsersResult {
            case .success:
                print("Users observed successfully")
            case .failure(let error):
                print("Failed to observe users: \(error.localizedDescription)")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                observeMessagesAndComplete(completion)
                observeTeamAndComplete(completion)
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
                print("Team observed successfully")
            case .failure(let error):
                print("Failed to observe messages: \(error.localizedDescription)")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    //
    //        DispatchQueue.main.async {
    //            TeamAPI.shared.observeTeams(completion: observeCompletion)
    //
    //        }
    //
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    //            EventAPI.shared.observeEventsFromTeam { result in
    //                switch result {
    //                case .success():
    //                    completion()
    //
    //                case .failure(let error):
    //                    print(error.localizedDescription)
    //                    completion()
    //
    //                }
    //            }
    //        }
}

