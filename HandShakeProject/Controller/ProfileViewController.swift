//
//  ProfileViewController.swift
//  HandShakeProject
//
//  Created by Марк on 15.07.23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    lazy var logoutButton = interfaceBuilder.createButton()
    
    let interfaceBuilder = InterfaceBuilder()
    lazy var authViewModel = AuthViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
    }
    
    private func setUI() {
        setSubviews()
        setupConstraints()
        setupTargets()
    }
    
    private func setSubviews() {
        view.addSubviews(logoutButton)
    }
    
    private func setupTargets() {
        logoutButton.addTarget(self, action: #selector(logoutAction(_:)), for: .touchUpInside)
    }
}

// MARK: - Action

private extension ProfileViewController {
    
    @objc
    private func logoutAction(_ sender: Any) {
        authViewModel.userLogoutAction() 
    }
}
