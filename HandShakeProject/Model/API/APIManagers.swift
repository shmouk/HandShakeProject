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
            completion()
        }
    }
    
    func loadSingletonData(completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            UserAPI.shared.observeUsers { _ in }
            ChatAPI.shared.observeMessages { _ in }
            TeamAPI.shared.observeTeams { _ in}
            completion()
        }
    }
}
