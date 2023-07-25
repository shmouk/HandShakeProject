//
//  Firebase + Extension.swift
//  HandShakeProject
//
//  Created by Марк on 24.07.23.
//

import Firebase

final class SetupDatabase {
        func setDatabase() -> DatabaseReference {
            Database.database(url: "https://handshake-project-ios-default-rtdb.europe-west1.firebasedatabase.app").reference()
    }
}
