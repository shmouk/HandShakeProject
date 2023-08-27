import Firebase

final class SetupDatabase {
        func setDatabase() -> DatabaseReference {
            Database.database(url: "https://handshake-project-ios-default-rtdb.europe-west1.firebasedatabase.app").reference()
    }
}
