import Firebase

class UserViewModel {
    private let userAPI = UserAPI.shared
    private let userDefaults = UserDefaultsManager.shared
    
    var users = Bindable([User()])
    
    func observeUsers() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            users.value = userAPI.users
        }
    }
}
