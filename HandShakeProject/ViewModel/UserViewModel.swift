import Firebase

class UserViewModel {
    private let userAPI = UserAPI.shared
    
    var users = Bindable([User()])
    
    init() {
        userAPI.notificationCenterManager.addObserver(self, selector: #selector(updateUsers), forNotification: .userNotification)
    }
    
    deinit {
        userAPI.notificationCenterManager.removeObserver(self, forNotification: .userNotification)
    }
    
    func observeUsers() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            users.value = userAPI.users
        }
    }
    func observeUsersWithoutMe(completion: @escaping ([User]) -> ()) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            var users = userAPI.users
            users = users.filter({$0.uid != User.fetchCurrentId()})
            completion(users)
        }
    }
}

extension UserViewModel {
    @objc
    private func updateUsers() {
        observeUsers()
    }
}
