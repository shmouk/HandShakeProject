import UIKit

class APIManager {

    func clearSingletonData(completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            UserAPI.shared.removeData()
            ChatAPI.shared.removeData()
            TeamAPI.shared.removeData()
            EventAPI.shared.removeData()
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
