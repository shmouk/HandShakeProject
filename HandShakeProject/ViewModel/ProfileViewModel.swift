//
//  ProfileViewModel.swift
//  HandShakeProject
//
//  Created by Марк on 26.07.23.
//

import UIKit

class ProfileViewModel {
    var nameText = Bindable("")
    var emailText = Bindable("")
    var profileImage = Bindable(UIImage())
    let userAPI = UserAPI.shared

    func fetchUser() {
        userAPI.loadCurrentUser { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                guard let image = user.image else { return }
                self.profileImage.value = image
                self.nameText.value = user.name
                self.emailText.value = user.email
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func loadImagePicker(image: UIImage) {
        userAPI.uploadImageToFirebaseStorage(image: image, completion: { result in
            
        })
    }
}
