//
//  AuthViewModel.swift
//  HandShakeProject
//
//  Created by Марк on 14.07.23.
//

import Foundation

class AuthViewModel {
    
    var statusText = Bindable("")
    
    func userButtonPressed(login: String, password: String) {
        if login != User.users[0].login || password != User.users[0].password {
            statusText.value = "Log in failed"
        }
        else {
            statusText.value = "Successed"
        }
    }
}
