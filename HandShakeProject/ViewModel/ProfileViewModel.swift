import UIKit

class ProfileViewModel {
    var currentUser = Bindable(User())
    let userAPI = UserAPI.shared

    func fetchUser(completion: @escaping () -> ()) {
        userAPI.fetchUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.currentUser.value = user
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                completion()
            }
        }
    }
    
    func loadImagePicker(image: UIImage) {
        userAPI.uploadImageToFirebaseStorage(image: image, completion: { result in
            
        })
    }
}
