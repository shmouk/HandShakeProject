//
//  ProfileViewController.swift
//  HandShakeProject
//
//  Created by Марк on 15.07.23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    lazy var logoutButton = interfaceBuilder.createButton()
    lazy var friendsButton = interfaceBuilder.createButton()
    lazy var editProfileButton = interfaceBuilder.createButton()
    lazy var nameLabel = interfaceBuilder.createTitleLabel()
    lazy var emailLabel = interfaceBuilder.createDescriptionLabel()
    lazy var profileImageView = interfaceBuilder.createImageView()

    let interfaceBuilder = InterfaceBuilder()
    lazy var authViewModel = AuthViewModel()
    lazy var profileViewModel = ProfileViewModel()
    lazy var usersAPI = UsersAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
    }
    
    private func setUI() {
        setSubviews()
        settingButton()
        setupConstraints()
        setupTargets()
        DispatchQueue.main.async { [self] in
            bindViewModel()
            setViews()
        }
    }
    
    private func setSubviews() {
        view.addSubviews(profileImageView, editProfileButton, emailLabel, nameLabel, friendsButton, logoutButton)
    }
    
    private func setViews() {
        profileViewModel.setImageView()
        profileViewModel.setText()
    }
    
    private func bindViewModel() {
        profileViewModel.nameText.bind { [self](nameText) in
            nameLabel.text = nameText
        }
        profileViewModel.emailText.bind { [self](emailText) in
            emailLabel.text = emailText
        }
        profileViewModel.profileImage.bind { [self](image) in
            profileImageView.image = image
        }
    }
    
    private func settingButton() {
        editProfileButton.setImage(UIImage(systemName: "pencil.line"), for: .normal)
        friendsButton.setTitle("Friends", for: .normal)
        logoutButton.setTitle("Logout", for: .normal)
    }
    
    
    private func setupTargets() {
        editProfileButton.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutAction(_:)), for: .touchUpInside)
        friendsButton.addTarget(self, action: #selector(openFriend(_:)), for: .touchUpInside)
    }
}

// MARK: - Action

private extension ProfileViewController {
    
    @objc
    private func openFriend(_ sender: Any) {
//        setViews()
    }
    
    @objc
    private func editProfile(_ sender: Any) {
        selectProfileImageView()
    }

    @objc
    private func logoutAction(_ sender: Any) {
        dismiss(animated: true)
        authViewModel.userLogoutAction()
    }
}
