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
