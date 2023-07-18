//
//  AuthViewModel.swift
//  HandShakeProject
//
//  Created by Марк on 14.07.23.
//

import Foundation
import FirebaseAuth

class AuthViewModel {
    
    var statusText = Bindable("")
    var signupBindable = Bindable(true)
    
    let firebaseAuth = Auth.auth()
    
    func changeAuthState() {
        signupBindable.value = !signupBindable.value
    }
    
    func userLoginAction(login: String, password: String, repeatPassword: String, state: Bool, completion: @escaping (Bool) -> Void) {
        guard !login.isEmpty, !password.isEmpty else {
            statusText.value = "Error: Empty fields"
            return
        }
        
        if state {
            guard password == repeatPassword else {
                statusText.value = "Error: Passwords do not match"
                return
            }
            
            firebaseAuth.createUser(withEmail: login, password: password) { [weak self] (result, error) in
                guard error == nil else {
                    self?.statusText.value = "Error: \(error!.localizedDescription)"
                    return
                }
                
                self?.statusText.value = "Success: User created"
                completion(true)
            }
        } else {
            firebaseAuth.signIn(withEmail: login, password: password) { [weak self] (result, error) in
                guard error == nil else {
                    self?.statusText.value = "Error: \(error!.localizedDescription)"
                    return
                }
                
                self?.statusText.value = "Success: User logged in"
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
