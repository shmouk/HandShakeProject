import Firebase
import UIKit

class EventAPI: APIClient {
    func startObserveNewData(ref: DatabaseReference) {
        return
    }
    
    static var shared = EventAPI()
    lazy var userApi = UserAPI.shared
    lazy var teamAPI = TeamAPI.shared
    
    var eventsData = [((UIImage, String), [Event])]()  {
        didSet {
            notificationCenterManager.postCustomNotification(named: .EventNotification)
        }
    }
    var teams: [Team]?
    
    var databaseReferenceData: [DatabaseReference]?
    
    private init() {
        notificationCenterManager.addObserver(self, selector: #selector(teamListDidChange(_:)), forNotification: .TeamNotification)
    }
    
    func removeData() {
        notificationCenterManager.removeObserver(self, forNotification: .TeamNotification)
        removeObserver()
        eventsData = removeData(data: &eventsData)
    }
    
    func writeToDatabase(_ teamId: String, _ eventData: [String : Any], completion: @escaping ResultCompletion) {
        let ref = SetupDatabase.setDatabase().child("events")
        let childRef = ref.childByAutoId()
        
        guard let eventId = childRef.key else { return }
        childRef.setValue(eventData) { [weak self] (error, _) in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
            } else {
                self.updateTeamEvents(teamId, eventId) { result in
                    switch result {
                    case .success():
                        let text = "Success added to database"
                        completion(.success(text))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func updateTeamEvents(_ teamId: String, _ eventID: String, completion: @escaping VoidCompletion) {
        let ref = SetupDatabase.setDatabase().child("teams").child(teamId).child("eventListId")
        let eventData: [String: Int] = [
            eventID: Int(Date().timeIntervalSince1970)
        ]
        
        ref.updateChildValues(eventData) { (error, _) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func observeEventsFromTeam(completion: @escaping VoidCompletion) {
        guard let uid = User.fetchCurrentId() else { return }
        let dispatchGroup = DispatchGroup()
        let teams = teamAPI.teams
        
        var eventsData = [((UIImage, String), [Event])]()
        
        for team in teams {
            dispatchGroup.enter()
            
            fetchEventList(team) { [weak self] eventIds in
                guard let self = self else { return }
                
                fetchEvents(for: team, eventIds: eventIds) { result in
                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            print("5. data", data.1.count)
                            eventsData.append(data)
                        }
                        
                    case .failure(let error):
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                    
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if !eventsData.isEmpty {
                self.eventsData = eventsData
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "No events found", code: 404, userInfo: nil)))
            }
        }
    }
    
    func fetchEventList(_ team: Team, completion: @escaping ([String]) -> Void) {
        DispatchQueue.main.async {
            guard let eventList = team.eventList else { return }
            completion(eventList)
        }
    }
    
    func fetchUserInfo(uid: String, completion: @escaping UserCompletion) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.userApi.fetchUser(uid: uid) { result in
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        completion(.success(user))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func fetchEvents(for team: Team, eventIds: [String], completion: @escaping (Result<((UIImage, String), [Event]), Error>) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            var events = [Event]()
            let dispatchGroup = DispatchGroup()
            
            for eventId in eventIds {
                dispatchGroup.enter()
                
                let ref = SetupDatabase.setDatabase().child("events").child(eventId)
                
                //                self.observerUIntData = ref.observe(.childAdded, with: { [weak self] snapshot in
                ref.observeSingleEvent(of: .value) { [weak self] snapshot in
                    defer { dispatchGroup.leave() }
                    
                    guard let self = self,
                          let eventDict = snapshot.value as? [String: Any],
                          let nameText = eventDict["name"] as? String,
                          let descriptionText = eventDict["description"] as? String,
                          let selectedState = eventDict["deadlineState"] as? Int,
                          let selectedDate = eventDict["date"] as? Int,
                          let selectedExecutorUser = eventDict["executor"] as? String
                    else { return }
                    
                    var executorData: User?
                    var creatorData: User?
                    var readerList: [String] = []
                    
                    dispatchGroup.enter()
                    self.fetchUserInfo(uid: selectedExecutorUser) { result in
                        
                        switch result {
                        case .success(let user):
                            executorData = user
                            dispatchGroup.leave()
                            print("1 fetchUserInfo")
                        case .failure(let error):
                            completion(.failure(error))
                            dispatchGroup.leave()
                        }
                    }
                    
                    dispatchGroup.enter()
                    self.fetchUserInfo(uid: team.creatorId) { result in
                        
                        switch result {
                        case .success(let user):
                            creatorData = user
                            dispatchGroup.leave()
                            print("2 fetchUserInfo")
                        case .failure(let error):
                            completion(.failure(error))
                            dispatchGroup.leave()
                        }
                    }
                    
                    dispatchGroup.enter()
                    self.fetchReaderList(for: ref) { resultList in
                        defer { dispatchGroup.leave() }
                        print("3 fetchReaderList")
                        readerList = resultList
                    }
                    
                    
                    dispatchGroup.notify(queue: .global(qos: .userInteractive)) {
                        dispatchGroup.enter()
                        guard let executorData = executorData, let creatorData = creatorData else {
                            completion(.failure(NSError(domain: "Failure load executor and creator data", code: 505, userInfo: nil)))
                            dispatchGroup.leave()
                            return
                        }
                        let event = Event(creatorInfo: creatorData,
                                          nameEvent: nameText,
                                          descriptionText: descriptionText,
                                          deadlineState: selectedState,
                                          date: selectedDate,
                                          executorInfo: executorData,
                                          readerList: readerList)
                        
                        events.append(event)
                        print("4 events.append")
                        dispatchGroup.leave()
                    }
                }
                //                )
            }
            
            dispatchGroup.notify(queue: .main) {
                print("5 events.count", events.count)
                guard let image = team.image else {
                    completion(.failure(NSError(domain: "Failure image data", code: 404, userInfo: nil)))
                    return
                }
                let dataTuple = ((image, team.teamName), events.sorted(by: { $0.date < $1.date }))
                
                completion(.success(dataTuple))
            }
        }
    }
    
    func fetchReaderList(for ref: DatabaseReference, completion: @escaping ([String]) -> Void) {
        ref.child("readerList").observeSingleEvent(of: .value) { snapshot in
            guard let userDict = snapshot.value as? [String: Int] else {
                completion([])
                return
            }
            
            let readerList = Array(userDict.keys)
            completion(readerList)
        }
    }
}
extension EventAPI {
    @objc func teamListDidChange(_ notification: Notification) {
        if let teams = notification.object as? [Team] {
            // Обработка изменения teamList
            print("Список команд изменился. Всего команд: \(teams.count)")
        }
    }
}
