import Firebase
import UIKit

class EventAPI: APIClient {
    func startObserveNewData(ref: DatabaseReference) {
        return
    }
    
    static var shared = EventAPI()
    lazy var userApi = UserAPI.shared
    lazy var teamAPI = TeamAPI.shared
    
    var eventsData = [((UIImage, String), [Event])]()

    var teams: [Team]?
    
    var databaseReferenceData: [DatabaseReference]?
    
    private init() {}
    
    func removeData() {
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
    
    func updateEventReadiness(_ event: Event) {
        let ref = SetupDatabase.setDatabase().child("events").child(event.eventId)
        let newValue = ["isReady": true]
        ref.updateChildValues(newValue)
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
        guard !teams.isEmpty else {
            completion(.success(()))
            return
        }
        
        var eventsData = [((UIImage, String), [Event])]()
        
        for team in teams {
            dispatchGroup.enter()
            print(team.eventList?.count)
            guard let eventList = team.eventList else {
                dispatchGroup.leave()
                continue
            }
            if !self.eventsData.contains(where: { $0.1.contains { event in eventList.contains(event.eventId) } }) {
                fetchEvents(for: team) { result in
                    switch result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            print("6. data", data.1.count)
                            eventsData.append(data)
                        }
                        
                    case .failure(let error):
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                    
                    dispatchGroup.leave()
                }
            } else {
                print("contain")
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            if !eventsData.isEmpty {
                self.eventsData = eventsData
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "No events found", code: 404, userInfo: nil)))
            }
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
    
    func fetchEvents(for team: Team, completion: @escaping (Result<((UIImage, String), [Event]), Error>) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            var events = [Event]()
            let dispatchGroup = DispatchGroup()
            let group = DispatchGroup()

            guard let eventList = team.eventList else {
                completion(.failure(NSError(domain: "Events not created", code: 500, userInfo: nil)))
                return }
            
            for eventId in eventList {
                dispatchGroup.enter()
                group.enter()
                let ref = SetupDatabase.setDatabase().child("events").child(eventId)
                
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
                    
                    
                    dispatchGroup.notify(queue: .main) {
                        dispatchGroup.enter()
                        guard let executorData = executorData, let creatorData = creatorData else {
                            completion(.failure(NSError(domain: "Failure load executor and creator data", code: 500, userInfo: nil)))
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
                        events.sort { $0.date < $1.date }
                        print("4 events.append")
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) {
                print("5 events.count", events.count)
                guard let image = team.image else {
                    completion(.failure(NSError(domain: "Failure image data", code: 404, userInfo: nil)))
                    return
                }


                let dataTuple = ((image, team.teamName), events)
                
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
    @objc func teamListDidChange() {

    }
}
