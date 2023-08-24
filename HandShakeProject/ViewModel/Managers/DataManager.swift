import Foundation
import UIKit

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let defaults = UserDefaults.standard

    private init() {}
    
    func saveValue<T>(_ value: T, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    func getValue<T>(forKey key: String) -> T? {
        return defaults.value(forKey: key) as? T
    }
    
    func removeData(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
}

class SingletonDataManager {
    static func clearSingletonData() {
        DispatchQueue.global().async {
            UserAPI.shared.users.removeAll()
            ChatAPI.shared.allMessages.removeAll()
            ChatAPI.shared.lastMessageFromMessages.removeAll()
            TeamAPI.shared.teams.removeAll()
        }
    }
    
    static func loadSingletonData() {
        DispatchQueue.global().async {
            UserAPI.shared.observeUsers { _ in }
            ChatAPI.shared.observeMessages { _ in }
            TeamAPI.shared.observeTeams { _ in }
        }
    }
}



