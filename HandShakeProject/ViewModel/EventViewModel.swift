import UIKit
import Foundation

class EventViewModel {
    private let eventAPI = EventAPI.shared
    private let userDefaults = UserDefaultsManager.shared
    private var withUser: User?
    lazy var userAPI = UserAPI.shared
    
    var currentTeam = Bindable(Team())
    var otherTeams = Bindable([Team()])
    var fetchUsersFromSelectedTeam = Bindable([User()])
    var userNames = Bindable([String()])
    var eventData = Bindable([((UIImage, String), [Event])]())
    
    init() {
        eventAPI.notificationCenterManager.addObserver(self, selector: #selector(updateEvent), forNotification: .EventNotification)
    }
    
    deinit {
        eventAPI.notificationCenterManager.removeObserver(self, forNotification: .EventNotification)
    }
    
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

    func convertIdToNames(ids: [String]) {
        let users = userAPI.users
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let dispatchGroup = DispatchGroup()
            var names: [String] = []
            
            for id in ids {
                dispatchGroup.enter()
                
                eventAPI.convertIdToUserName(users: users, id: id) { name in
                    names.append(name)
                    defer {
                        dispatchGroup.leave()
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.userNames.value = names
            }
        }
    }
 
    func fetchCurrentTeam(_ teams: [Team]) {
        guard let ownTeam = teams.first, let list = ownTeam.userList  else { return }
        currentTeam.value = ownTeam
        convertIdToNames(ids: list)
        fetchUsersFromUserList(team: ownTeam)
    }
    
    
    func fetchEventData() {
        eventData.value = eventAPI.eventsData
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

extension EventViewModel {
    @objc
    private func updateEvent() {
        fetchEventData()
    }
}


