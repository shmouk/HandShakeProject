import Foundation

class TeamViewModel {
    let teamAPI = TeamAPI.shared
    
    var lastMessageArray: Bindable<[Message]> = Bindable([])
    var newMessageReceived: Bindable<[Message]> = Bindable([])
    var filterMessages: Bindable<[Message]> = Bindable([])
    
    var fetchUser: Bindable<User> = Bindable(User())
    var users: Bindable<[User]> = Bindable([])
    var test = [User(uid: "123", email: "123", name: "123", downloadURL: "123"),
                User(uid: "222", email: "455", name: "666", downloadURL: "177723")]
    static var currentUID = UserAPI.shared.currentUID
    
    init() {
    }
    
    func createTeam(_ text: String) {
        teamAPI.writeToDatabase(text) { _ in
            
        }
    }
    
    func loadTeam() {
        teamAPI.observeTeams { _ in }
    }
}
