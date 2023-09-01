import Foundation
import Firebase
import FirebaseStorage

protocol ObservableAPI: AnyObject {
    var databaseReferanceData: [DatabaseReference]? { get set }
    func removeObserver()
    func removeData<T>(data: inout [T]) -> [T]
}

extension ObservableAPI {
    func removeObserver() {
        guard let dataReferances = databaseReferanceData else { return }
        
        dataReferances.forEach { referance in
            referance.removeAllObservers()
        }
    }

    func removeData<T>(data: inout [T]) -> [T] {
        data.removeAll()
        return data
    }
}
