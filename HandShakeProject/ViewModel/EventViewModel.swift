import UIKit
import Foundation

class EventViewModel {
    private let eventAPI = EventAPI.shared
    private let userDefaults = UserDefaultsManager.shared
    private var withUser: User?
    
    var currentTeam = Bindable(Team())
    var otherTeams = Bindable([Team()])
    var fetchUsersFromSelectedTeam = Bindable([User()])
    var userNames = Bindable([String()])
    var eventData = Bindable([((UIImage, String), [Event])]())

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
        var userListDict = [String: Int]()
        if let userList = currentTeam.value.userList {
            for user in userList {
                userListDict[user] = 0
            }
        }

        var eventData = [String : Any]()
        eventData["name"] = nameText
        eventData["description"] = descriptionText
        eventData["deadlineState"] = stateIndex
        eventData["date"] = date
        eventData["executor"] = executorUid
        eventData["readerList"] = userListDict
        
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
    
    func convertIdToUserName(ids: [String]) {
        eventAPI.convertIdToUserName(ids) { [weak self] names in
            guard let self = self else { return }
            self.userNames.value = names
        }
    }
    
    func fetchCurrentTeam(_ teams: [Team]) {
        guard let ownTeam = teams.first, let list = ownTeam.userList  else { return }
        self.currentTeam.value = ownTeam
        self.convertIdToUserName(ids: list)
        self.fetchUsersFromUserList(team: ownTeam)
    }
    
    
    func fetchEventData() {
        self.eventData.value = eventAPI.eventsData
    }
    
    func fetchTeams(completion: @escaping (String) -> Void) {
        TeamAPI.shared.filterTeams { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success((let ownTeams, _)):
                
                self.fetchCurrentTeam(ownTeams)
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



