import UIKit


class APIManager {
    //    static let shared = APIManager()
    //
    //    private init() {}
    //
    func clearSingletonData(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            UserAPI.shared.users.removeAll()
            ChatAPI.shared.allMessages.removeAll()
            ChatAPI.shared.lastMessageFromMessages.removeAll()
            TeamAPI.shared.teams.removeAll()
            EventAPI.shared.eventsData.removeAll()
            completion()
        }
    }
    
    func loadSingletonData(completion: @escaping () -> Void) {
         
        UserAPI.shared.observeUsers { result in
            switch result {
            case .success():
                break
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
        
        DispatchQueue.main.async {
            ChatAPI.shared.observeMessages { result in
                
                switch result {
                case .success():
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        DispatchQueue.main.async {
            TeamAPI.shared.observeTeams { result in
                switch result {
                case .success():
                    DispatchQueue.main.async {
                        EventAPI.shared.observeEventsFromTeam { result in
                            switch result {
                            case .success():
                                completion()
                                break
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
        }
    }
}
