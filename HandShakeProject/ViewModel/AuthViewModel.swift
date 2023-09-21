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
    
    private func setStatusText(_ message: String) {
        self.statusText.value = message
    }
    
    func userLoginAction(email: String, password: String, repeatPassword: String) {
        guard !email.isEmpty, !password.isEmpty else {
            setStatusText("Error: Empty fields")
            return
        }
        
        if isSigningUp.value {
            guard password == repeatPassword else {
                setStatusText("Error: Passwords do not match")
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
                guard let self = self else { return }
                if let error = error {
                    self.setStatusText("Error: " + error.localizedDescription)
                    return
                }
                
                guard let uid = result?.user.uid else {
                    self.setStatusText("Error: Could not retrieve user ID")
                    return
                }
                
                self.userAPI.writeToDatabase(uid: uid, email: email)
            }
        } else {
            guard isValidEmail(email: email) else {
                setStatusText("Incorrect email address")
                return
            }
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
                guard let self = self else { return }
                if let error = error {
                    self.setStatusText("Error: \(error.localizedDescription)")
                    return
                }
                
            }
        }
    }
    
    private func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
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
