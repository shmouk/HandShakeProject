
import Foundation

class EventViewModel {
    private let eventAPI = EventAPI.shared
    private let userDefaults = UserDefaultsManager.shared
    private var withUser: User?
    
    var currentTeam = Bindable(Team())

    var fetchUsersFromSelectedTeam = Bindable([User()])
    var userNames = Bindable([String()])
    
    func createEvent(nameText: String?, descriptionText: String?, selectedState: Int?, selectedDate: Int?, selectedExecutorUser: String?,  completion: @escaping ResultCompletion) {
        
        guard let nameText = nameText else {
            completion(.failure(NSError(domain: "Empty name event,", code: 400, userInfo: nil)))
            return
        }
  
        if descriptionText == nil || descriptionText == "Input text"  {
            completion(.failure(NSError(domain: "Input description text,", code: 400, userInfo: nil)))
            return
        }
        guard let stateIndex = selectedState else {
            completion(.failure(NSError(domain: "Deadline not choosen,", code: 400, userInfo: nil)))
            return
        }
        
        guard let date = selectedDate else {
            completion(.failure(NSError(domain: "Date not choosen,", code: 400, userInfo: nil)))
            return
        }
        
        guard let executorUid = selectedExecutorUser else {
            completion(.failure(NSError(domain: "Exector not choosen,", code: 400, userInfo: nil)))
            return
        }
        
        var eventData  = [String : Any]()
        
        eventData["name"] = nameText
        eventData["description"] = descriptionText
        eventData["deadlineState"] = selectedState
        eventData["date"] = selectedDate
        eventData["executor"] = selectedExecutorUser
        eventData["readerList"] = currentTeam.value.userList
        
        eventAPI.writeToDatabase(currentTeam.value.teamId, eventData) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let text):
                completion(.success(text))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func convertIdToUserName(ids: [String]) {
        eventAPI.convertIdToUserName(ids) { [weak self] names in
            guard let self = self else { return }
            self.userNames.value = names
        }
    }
    
    func fetchCurrentTeam(completion: @escaping (String) -> Void) {
        TeamAPI.shared.filterTeams { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success((let ownTeams, _)):
                guard let ownTeam = ownTeams.first, let list = ownTeam.userList else { return }
                self.currentTeam.value = ownTeam
                self.convertIdToUserName(ids: list)
                self.fetchUsersFromUserList(team: ownTeam)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    private func fetchUsersFromUserList(team : Team) {
        TeamAPI.shared.fetchUserFromTeam(team) { [weak self] users in
            guard let self = self else { return }
            self.fetchUsersFromSelectedTeam.value = users
        }
    }
}



