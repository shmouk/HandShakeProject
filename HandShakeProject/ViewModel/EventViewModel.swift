
import Foundation

class EventViewModel {
    private let eventAPI = EventAPI.shared
    private let userDefaults = UserDefaultsManager.shared
    private var withUser: User?
    
    var currentTeam = Bindable([Team()])
    var filterMessages = Bindable([Message()])
    
    var fetchUser = Bindable(User())
    var users = Bindable([User()])
    
    func createEvent(_ eventData: [String : Any],  completion: @escaping ResultCompletion) {
        eventAPI.writeToDatabase(eventData) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let text):
                completion(.success(text))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchCurrentTeam(completion: @escaping (String) -> Void) {
        TeamAPI.shared.filterTeams { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success((let ownTeams, _)):
                self.currentTeam.value = ownTeams
                
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
}



