import Firebase

class AuthViewModel {
    private let userDefaults = UserDefaultsManager.shared
    private let userAPI = UserAPI.shared
    
    var loadingViewSwitcher = Bindable(Bool())
    var statusText = Bindable(String())
    var isSigningUp = Bindable(true)
    
    init() {
        userAPI.notificationCenterManager.addObserver(self, selector: #selector(loadingViewHandle), forNotification: .loadDataNotification)
    }
    
    deinit {
        userAPI.notificationCenterManager.removeObserver(self, forNotification: .loadDataNotification)
    }
    
    func toggleAuthState() {
        isSigningUp.value = !isSigningUp.value
    }
    
    func userLoginAction(email: String, password: String, repeatPassword: String) {
        guard !email.isEmpty, !password.isEmpty else {
            statusText.value = "Error: Empty fields"
            return
        }
        
        if isSigningUp.value {
            guard password == repeatPassword else {
                statusText.value = "Error: Passwords do not match"
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
                guard let self = self else { return }
                guard error == nil, let uid = result?.user.uid else {
                    self.statusText.value = "Error: \(String(describing: error?.localizedDescription))"
                    return
                }
                
                self.userAPI.writeToDatabase(uid: uid, email: email)
            }
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
                guard let self = self else { return }
                
                guard error == nil else {
                    self.statusText.value = "Error: \(String(describing: error?.localizedDescription))"
                    return
                }
            }
        }
    }
    
    func authStateListener(completion: @escaping VoidCompletion) {
        Auth.auth().addStateDidChangeListener { [weak self](auth, user) in
            guard let self = self else { return }
            if user == nil {
                completion(.failure(NSError(domain: "User logout,", code: 403, userInfo: nil)))
            }
            else {
                userAPI.notificationCenterManager.postCustomNotification(named: .loadDataNotification)
                APIManager.loadSingletonData {
                    completion(.success(()))
                }
            }
        }
    }
    
    func userLogoutAction() {
        APIManager.clearSingletonData { [weak self] in
            guard let self = self else { return }
            userDefaults.removeData(forKey: "messagesCount")
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
    }
}
extension AuthViewModel {
    @objc
    func loadingViewHandle() {
        loadingViewSwitcher.value = true
    }
}
