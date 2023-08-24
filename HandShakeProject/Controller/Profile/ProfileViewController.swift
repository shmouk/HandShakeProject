//
//  ProfileViewController.swift
//  HandShakeProject
//
//  Created by Марк on 15.07.23.
//

import UIKit

class ProfileViewController: UIViewController {
    private let navigationBarManager = NavigationBarManager()
    private let interfaceBuilder = InterfaceBuilder()
    private let authViewModel = AuthViewModel()

    let profileViewModel = ProfileViewModel()
    
    lazy var activityIndicator = interfaceBuilder.createActivityIndicator()
    lazy var logoutButton = interfaceBuilder.createButton()
    lazy var friendsButton = interfaceBuilder.createButton()
    lazy var editProfileButton = interfaceBuilder.createButton()
    lazy var nameLabel = interfaceBuilder.createTitleLabel()
    lazy var emailLabel = interfaceBuilder.createDescriptionLabel()
    lazy var profileImageView = interfaceBuilder.createImageView()
 
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("4")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        loadData()
    }
    
    private func setUI() {
        setupNavBarManager()
        setSubviews()
        settingButton()
        settingImage()
        setupConstraints()
        setupTargets()
    }
    
    private func setSubviews() {
        view.addSubviews(activityIndicator, profileImageView, editProfileButton, emailLabel, nameLabel, friendsButton, logoutButton)
        view.backgroundColor = .colorForView()
    }

    func loadData() {
        activityIndicator.startAnimating()
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            self.profileViewModel.fetchUser() { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    
    
    private func bindViewModel() {
        profileViewModel.currentUser.bind { [weak self] user in
            guard let self = self else { return }
            nameLabel.text = user.name
            emailLabel.text = user.email
            profileImageView.image = user.image
        }
    }
    
    private func settingImage() {
        editProfileButton.setImage(UIImage(systemName: "pencil.line"), for: .normal)
    }
    
    private func settingButton() {
        friendsButton.setTitle("Friends", for: .normal)
        logoutButton.setTitle("Logout", for: .normal)
    }
    
    private func setupNavBarManager() {
        navigationBarManager.delegate = self
        navigationBarManager.updateNavigationBar(for: self, isAddButtonNeeded: false)
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
        
    }
    
    @objc
    private func editProfile(_ sender: Any) {
        selectProfileImageView()
    }
    
    @objc
    private func logoutAction(_ sender: Any) {
        authViewModel.userLogoutAction()
    }
}

extension ProfileViewController: NavigationBarManagerDelegate {
    func didTapNotificationButton() {}
    
    func didTapAddButton() {
    }
}
