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
    
    func userButtonPressed(login: String, password: String, repeatPassword: String, state: Bool, completion: @escaping (Bool) -> ()) {
                switch state {
                case true:
                    guard password == repeatPassword else {
                        self.statusText.value = "Error password"
                        return
                    }
                    Auth.auth().createUser(withEmail: login, password: password) { [weak self] (result, error) in
                        guard error == nil else {
                            self?.statusText.value = "Error sign up"
                            return
                        }
                        self?.statusText.value = "Successed sign up"
                        completion(true)

                    }
                case false:
                    Auth.auth().signIn(withEmail: login, password: password) { [weak self] (result, error) in
                        guard error == nil else {
                            self?.statusText.value = "Error sign in"
                            return
                        }
                        self?.statusText.value = "Successed sign in"
                            completion(true)
                    }
                }
            }
}
