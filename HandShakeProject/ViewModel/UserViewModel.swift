import Firebase

class UserViewModel {
    private let userAPI = UserAPI.shared
    private let userDefaults = UserDefaultsManager.shared
    
    var users = Bindable([User()])
    
    init() {
        userAPI.notificationCenterManager.addObserver(self, selector: #selector(updateUsers), forNotification: .UserNotification)
    }
    
    deinit {
        userAPI.notificationCenterManager.removeObserver(self, forNotification: .UserNotification)
    }
    
    func observeUsers() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            users.value = userAPI.users
        }
    }
}

extension UserViewModel {
    @objc
    private func updateUsers() {
        observeUsers()
    }
}
