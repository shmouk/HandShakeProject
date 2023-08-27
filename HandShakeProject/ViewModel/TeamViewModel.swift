import Foundation

class TeamViewModel {
    let teamAPI = TeamAPI.shared
    
    var fetchUser = Bindable(User())
    var ownTeams = Bindable([Team()])
    var otherTeams = Bindable([Team()])
    var selectedTeam = Bindable(Team())
    var fetchUsersFromSelectedTeam = Bindable([User()])
    var creatorName = Bindable(String())
    var satusText = Bindable(String())
    
    init() {
    }
    
    func createTeam(_ text: String) {
        teamAPI.writeToDatabase(text) { _ in
            
        }
    }
    
    func filterTeam() {
        teamAPI.filterTeams { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success((let ownTeams, let otherTeams)):
                self.ownTeams.value = ownTeams
                self.otherTeams.value = otherTeams
                
            case .failure(_):
                break
            }
        }
    }
    
    func searchUserEmail(_ email: String) {
        teamAPI.searchUserFromDatabase(email) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.satusText.value = "Found user!"
                fetchUser.value = user
                
            case .failure(_):
                self.satusText.value = "No user found!"
            }
        }
    }
    
    func convertIdToUserName(id: String) {
        teamAPI.convertIdToUserName(id: id) { [weak self] name in
            guard let self = self else { return }
            self.creatorName.value = name
        }
    }
    
    func fetchUsersFromUserList(team: Team) {
        teamAPI.fetchUserFromTeam(team) { [weak self] users in
            guard let self = self else { return }
            self.fetchUsersFromSelectedTeam.value = users
        }
    }
    
    func fetchSelectedTeam(_ selectedTeam: Team) {
        teamAPI.fetchSelectedTeam(selectedTeam) { [weak self] team in
            guard let self = self else { return }
            self.selectedTeam.value = team
        }
    }
    
    func addUserToTeam(_ user: User, to team: Team, completion: @escaping ResultCompletion) {
        teamAPI.addUserToDatabase(user, to: team) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.satusText.value = ""
                completion(.success("User added to team"))
                
            case .failure(let error):
                self.satusText.value = error.localizedDescription
                break
            }
        }
    }
}
