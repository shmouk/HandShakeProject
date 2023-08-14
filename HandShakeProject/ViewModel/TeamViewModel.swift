import Foundation

class TeamViewModel {
    let teamAPI = TeamAPI.shared
    
    var fetchUser = Bindable(User())
    var ownTeams = Bindable([Team()])
    var otherTeams = Bindable([Team()])
    var selectedTeam = Bindable(Team())
    var fetchUsersFromSelectedTeam = Bindable([User()])

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
    
    func fetchUserFromUserList(team : Team) {
        teamAPI.fetchUserFromTeam(team) { [weak self] users in
            guard let self = self else { return }
            self.fetchUsersFromSelectedTeam.value = users
            print(1)
        }
    }
    
    func fetchSelectedTeam(_ selectedTeam: Team) {
        teamAPI.fetchSelectedTeam(selectedTeam) { [weak self] team in
            guard let self = self, let team = team else { return }
            self.selectedTeam.value = team
        }
    }
    
    func settingSections() -> [String] {
        let firstSection = "Your Teams"
        let secondSection = "Other Teams"
        var sections: [String] = []
        if !ownTeams.value.isEmpty {
            sections.append(firstSection)
        }
        if !otherTeams.value.isEmpty {
            sections.append(secondSection)
        }
        return sections
    }
}
