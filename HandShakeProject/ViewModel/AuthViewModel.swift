import Firebase

class AuthViewModel {
    
    var statusText = Bindable("")
    var isSigningUp = Bindable(true)
    lazy var firebaseAuth = Auth.auth()
    let userAPI = UserAPI.shared
    
    func toggleAuthState() {
        isSigningUp.value = !isSigningUp.value
    }
    
    func userLoginAction(email: String, password: String, repeatPassword: String, completion: @escaping (Bool) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            statusText.value = "Error: Empty fields"
            return
        }
        
        if isSigningUp.value {
            guard password == repeatPassword else {
                statusText.value = "Error: Passwords do not match"
                return
            }
            
            firebaseAuth.createUser(withEmail: email, password: password) { [weak self] (result, error) in
                guard let self = self else { return }
                guard error == nil else {
                    self.statusText.value = "Error: \(error!.localizedDescription)"
                    return
                }
                
                self.userAPI.writeToDatabase(uid: result?.user.uid ?? "", email: email)
                self.statusText.value = "Success: User created"
                completion(true)
            }
        } else {
            firebaseAuth.signIn(withEmail: email, password: password) { [weak self] (result, error) in
                guard let self = self else { return }
                
                guard error == nil else {
                    self.statusText.value = "Error: \(error!.localizedDescription)"
                    return
                }
                
                self.statusText.value = "Success: User logged in"
                completion(true)
            }
        }
    }
    
    func userLogoutAction() {
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
