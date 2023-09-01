import Foundation

final class Do {
    static func make(withHandle: UInt) {
        print("do.make")
    }
}

protocol ObservableAPI: AnyObject {
    var observerUIntData: [UInt]? { get set }
    func removeObserver()
    func removeData<T>(_ data: inout [T]) -> [T]
}

extension ObservableAPI {
    func removeObserver() {
        observerUIntData?.forEach { handle in
            Do.make(withHandle: handle)
        }
        if let observerData = observerUIntData {
            var tempObserverData = observerData
            observerUIntData = removeData(&tempObserverData)
        }
    }
    
    func removeData<T>(_ data: inout [T]) -> [T] {
        data.removeAll()
        return data
    }
}

class UserAPI: ObservableAPI {
    var observerUIntData: [UInt]?
        
    static let shared = UserAPI()
    
    private init() { }
    
    var users: [Int] = [1, 2, 3, 4]
    
    func removeData() {
        let data = [123, 234, 4654]
        observerUIntData?.append(data)
        print(4, observerUIntData)
        removeObserver()
        removeData(&users)
    }
}



let api = UserAPI.shared

api.removeData()
print(3, api.observerUIntData)
