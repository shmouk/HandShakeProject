import Foundation
import Firebase
import FirebaseStorage

protocol ObservableAPI: AnyObject {
    var observerUIntData: [UInt]? { get set }
    func removeObserver()
    func removeData<T>(data: inout [T]) -> [T]
}

extension ObservableAPI {
    func removeObserver() {
        guard var observerData = observerUIntData else { return }
        
        observerData.forEach { handle in
            SetupDatabase.setDatabase().removeObserver(withHandle: handle)
        }
        observerUIntData = removeData(data: &observerData)
    }

    func removeData<T>(data: inout [T]) -> [T] {
        data.removeAll()
        return data
    }
}
