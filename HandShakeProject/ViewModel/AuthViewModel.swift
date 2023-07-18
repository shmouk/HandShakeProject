//
//  AuthViewModel.swift
//  HandShakeProject
//
//  Created by Марк on 14.07.23.
//

import Foundation
import Firebase

class AuthViewModel {
    
    var statusText = Bindable("")
    var signupBindable = Bindable(true)
    
    let firebaseAuth = Auth.auth()
    let ref = Database.database().reference()
    
    func changeAuthState() {
        signupBindable.value = !signupBindable.value
    }
    
    func writeToDatabase(uid: String, email: String) {
        let userRef = Database.database(url: "https://handshake-project-ios-default-rtdb.europe-west1.firebasedatabase.app").reference().child("users").child(uid)
        let userData = ["email": email]
        
        userRef.setValue(userData) { (error, databaseRef) in
            if let error = error {
                print("Error writing user to Firebase: \(error.localizedDescription)")
            } else {
                print("User data successfully written to Firebase")
            }
        }
    }

    
    func userLoginAction(email: String, password: String, repeatPassword: String, state: Bool, completion: @escaping (Bool) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            statusText.value = "Error: Empty fields"
            return
        }
        
        if state {
            guard password == repeatPassword else {
                statusText.value = "Error: Passwords do not match"
                return
            }
            
            firebaseAuth.createUser(withEmail: email, password: password) { [weak self] (result, error) in
                guard error == nil else {
                    self?.statusText.value = "Error: \(error!.localizedDescription)"
                    return
                }
                
                self?.writeToDatabase(uid: result?.user.uid ?? "", email: email)
                self?.statusText.value = "Success: User created"
                completion(true)
            }
        } else {
            firebaseAuth.signIn(withEmail: email, password: password) { [weak self] (result, error) in
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
                statusText.value = "" 
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
    }
}
