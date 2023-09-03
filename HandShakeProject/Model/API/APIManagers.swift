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

        let observeCompletion: VoidCompletion = { result in
            switch result {
            case .success():
                print("success")
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        UserAPI.shared.observeUsers (completion: observeCompletion)
        
        DispatchQueue.main.async {
            ChatAPI.shared.observeMessages(completion: observeCompletion)
        }
        
        DispatchQueue.main.async {
            TeamAPI.shared.observeTeams(completion: observeCompletion)
        }
        
        DispatchQueue.main.async {
            EventAPI.shared.observeEventsFromTeam(completion: observeCompletion)
        }
        
        completion()
    }
}
