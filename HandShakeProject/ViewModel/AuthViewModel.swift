import Firebase

class AuthViewModel {
    private let userDefaults = UserDefaultsManager.shared
    private let userAPI = UserAPI.shared

    var statusText = Bindable(String())
    var isSigningUp = Bindable(true)
    
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
                guard error == nil else {
                    self.statusText.value = "Error: \(error!.localizedDescription)"
                    return
                }
                
                self.userAPI.writeToDatabase(uid: result?.user.uid ?? "", email: email)
            }
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
                guard let self = self else { return }
                
                guard error == nil else {
                    self.statusText.value = "Error: \(error!.localizedDescription)"
                    return
                }
            }
        }
    }
    
    func authStateListener(completion: @escaping VoidCompletion) {
        Auth.auth().addStateDidChangeListener { [weak self](auth, user) in
            guard let self = self else { return }
            if user == nil {
                completion(.failure(NSError(domain: "User logout", code: 403, userInfo: nil)))
            }
            else {
                SingletonDataManager.loadSingletonData()
                completion(.success(()))
                print(123)
            }
        }
    }
    
    func userLogoutAction() {
        SingletonDataManager.clearSingletonData()
        userDefaults.removeData(forKey: "messagesCount")
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
