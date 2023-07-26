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
    lazy var usersAPI = UsersAPI()
    
    func setImageView() {
        usersAPI.currentUser { [weak self] result in
            switch result {
            case .success(let user):
                guard let image = user.image else { return }
                self?.profileImage.value = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setText() {
        usersAPI.currentUser { [weak self] result in
            switch result {
            case .success(let user):
                self?.nameText.value = user.name
                self?.emailText.value = user.email
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
