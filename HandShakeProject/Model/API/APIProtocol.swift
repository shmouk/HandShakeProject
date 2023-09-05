import Foundation
import Firebase
import FirebaseStorage
import UIKit



protocol APIClient: AnyObject {
    var databaseReferenceData: [DatabaseReference]? { get set }
    var notificationCenterManager: NotificationCenterManager { get }
    func removeObserver()
    func startObserveNewData(ref: DatabaseReference) 
    func removeData<T>(data: inout [T]) -> [T]
    func downloadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void)
    func downloadDefaultImageString(childFolderName: String, childImageName: String, completion: @escaping ResultCompletion)
}

extension APIClient {
    var notificationCenterManager: NotificationCenterManager {
            return NotificationCenterManager.shared
        }

    func removeObserver() {
        guard let dataReferences = databaseReferenceData else { return }
        
        dataReferences.forEach { reference in
            reference.removeAllObservers()
        }
    }
    
    func removeData<T>(data: inout [T]) -> [T] {
        data.removeAll()
        return data
    }
    
    func downloadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                    }
                }
                return
            }
            
            guard let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "Invalid image data,", code: 400, userInfo: nil)))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }.resume()
    }
    func downloadDefaultImageString(childFolderName: String, childImageName: String, completion: @escaping ResultCompletion){
        let defaultImageRef = Storage.storage().reference().child(childFolderName).child(childImageName)
        defaultImageRef.downloadURL { url, error in
            guard let imageURL = url else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            
            completion(.success(imageURL.absoluteString))
        }
    }
    
    func convertIdToUserName(users: [User], id: String, completion: @escaping (String) -> Void) {
        DispatchQueue.global().async {
            guard let userName = users.first(where: { $0.uid == id })?.name else { return }
            
            DispatchQueue.main.async {
                completion(userName)
            }
        }
    }
}
