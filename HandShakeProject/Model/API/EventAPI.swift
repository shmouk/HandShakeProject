import Firebase
import UIKit

class EventAPI: ObservableAPI {
    static var shared = EventAPI()
    var eventsData = [((UIImage, String), [Event])]()
    
    var databaseReferanceData: [DatabaseReference]?
    
    private init() {}
    
    func removeData() {
        removeObserver()
        eventsData = removeData(data: &eventsData)
    }
    
    func writeToDatabase(_ teamId: String, _ eventData: [String : Any], completion: @escaping ResultCompletion) {
        let ref = SetupDatabase.setDatabase().child("events")
        let childRef = ref.childByAutoId()
        
        guard let eventId = childRef.key else { return }
        childRef.setValue(eventData) { (error, _) in
            if let error = error {
                completion(.failure(error))
            } else {
                self.updateTeamEvents(teamId, eventId) { [weak self] result in
                    guard let self = self else { return }
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
        let teams = TeamAPI.shared.teams
        
        var eventsData = [((UIImage, String), [Event])]()
        
        for team in teams {
            dispatchGroup.enter()
            
            fetchEventList(team) { eventIds in
                self.fetchEvents(for: team, eventIds: eventIds) { result in
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
                completion(.failure(NSError(domain: "No events found", code: 401, userInfo: nil)))
            }
        }
    }
    
    func fetchEventList(_ team: Team, completion: @escaping ([String]) -> Void) {
        DispatchQueue.global().async {
            guard let eventList = team.eventList else { return }
            completion(eventList)
        }
    }
    
    func fetchUserInfo(uid: String, completion: @escaping UserCompletion) {
        DispatchQueue.global().async {
            UserAPI.shared.fetchUser(uid: uid) { result in
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
            let group = DispatchGroup()
            
            for eventId in eventIds {
                group.enter()
                
                let ref = SetupDatabase.setDatabase().child("events").child(eventId)
                
//                self.observerUIntData = ref.observe(.childAdded, with: { [weak self] snapshot in
                ref.observeSingleEvent(of: .value) { [weak self] snapshot in
                    defer { group.leave() }
                    
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
                    
                    group.enter()
                    self.fetchUserInfo(uid: selectedExecutorUser) { result in
                        
                        switch result {
                        case .success(let user):
                            executorData = user
                            group.leave()
                            print("1.1 fetchUserInfo")
                        case .failure(let error):
                            completion(.failure(error))
                            group.leave()
                        }
                    }
                    
                    group.enter()
                    self.fetchUserInfo(uid: team.creatorId) { result in
                        
                        switch result {
                        case .success(let user):
                            creatorData = user
                            group.leave()
                            print("1.2 fetchUserInfo")
                        case .failure(let error):
                            completion(.failure(error))
                            group.leave()
                        }
                    }
                    
                    group.enter()
                    self.fetchReaderList(for: ref) { resultList in
                        defer { group.leave() }
                        print("2. fetchReaderList")
                        readerList = resultList
                    }
                    
                    
                    group.notify(queue: .global(qos: .userInteractive)) {
                        group.enter()
                        guard let executorData = executorData, let creatorData = creatorData else {
                            completion(.failure(NSError(domain: "Failure load executor and creator data", code: 401, userInfo: nil)))
                            group.leave()
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
                        print("3. events.append")
                        group.leave()
                    }
                }
//                )
            }
            
            group.notify(queue: .main) {
                print("4. events.count", events.count)
                guard let image = team.image else {
                    completion(.failure(NSError(domain: "Failure image data", code: 401, userInfo: nil)))
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
    
    
    
    func convertIdToUserName(_ ids: [String], completion: @escaping ([String]) -> Void) {
        let users = UserAPI.shared.users
        DispatchQueue.global().async { [weak self] in
            guard self != nil else { return }
            
            var userNames: [String] = []
            
            for id in ids {
                if let userName = users.first(where: { $0.uid == id })?.name {
                    userNames.append(userName)
                }
            }
            
            DispatchQueue.main.async {
                completion(userNames)
            }
        }
    }
}

