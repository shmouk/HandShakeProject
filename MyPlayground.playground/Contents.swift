
func fetchUserInfo(uid: String, completion: @escaping Result) {
    UserAPI.shared.fetchUser(uid: uid) { result in
        
        completion(.success(result))
        
    }
}

