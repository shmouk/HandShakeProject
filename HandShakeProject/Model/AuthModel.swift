//
//  AuthModel.swift
//  HandShakeProject
//
//  Created by Марк on 14.07.23.
//

import Foundation

struct User {
    var login: String?
    var password: String?
}

extension User {
    static var users = [
        User(login: "123", password: "123")
    ]
}
