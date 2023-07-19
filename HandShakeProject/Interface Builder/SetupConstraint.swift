//
//  SetupConstraint.swift
//  HandShakeProject
//
//  Created by Марк on 14.07.23.
//

import UIKit

// MARK: - AuthorizationViewController Constraint

extension AuthorizationViewController {
    
    func setupConstraints() {
        
        let heightForView = view.frame.height / 14
        
        NSLayoutConstraint.activate([
            authSegmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            authSegmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            authSegmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            authSegmentControl.heightAnchor.constraint(equalToConstant: heightForView * 0.8)
        ])
        
        NSLayoutConstraint.activate([
            loginTextField.topAnchor.constraint(equalTo: authSegmentControl.bottomAnchor, constant: 30),
            loginTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            loginTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            loginTextField.heightAnchor.constraint(equalToConstant: heightForView)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 15),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passwordTextField.heightAnchor.constraint(equalToConstant: heightForView)
        ])
        
        NSLayoutConstraint.activate([
            repeatPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            repeatPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            repeatPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            repeatPasswordTextField.heightAnchor.constraint(equalToConstant: heightForView)
        ])
        
        NSLayoutConstraint.activate([
            statusAuthLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30 + heightForView),
            statusAuthLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            statusAuthLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            statusAuthLabel.heightAnchor.constraint(equalToConstant: heightForView)
        ])
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: statusAuthLabel.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            loginButton.heightAnchor.constraint(equalToConstant: heightForView)
        ])
    }
}

// MARK: - MainTabBarViewController Constraint

extension MainTabBarViewController {
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 44)
        ])
    }
}

// MARK: - ProfileViewController Constraint

extension ProfileViewController {
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            logoutButton.heightAnchor.constraint(equalToConstant: view.frame.height / 12)
        ])
    }
}

// MARK: - EventTableViewCell Constraint

extension EventTableViewCell{
    func setupConstraints() {
        
        let thirdWidth = frame.width / 3
        let halfHeight = frame.height / 2
        
        NSLayoutConstraint.activate([
            teamImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            teamImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            teamImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            teamImageView.heightAnchor.constraint(equalTo: teamImageView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: teamImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: frame.width / 3),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: frame.height / 2 + 10)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: teamImageView.trailingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: teamImageView.trailingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20),
            dateLabel.heightAnchor.constraint(equalTo: descriptionLabel.heightAnchor)
        ])
    }
}

// MARK: - ChatsTableVeiwCell Constraint

extension ChatsTableVeiwCell{
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            friendImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            friendImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            friendImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            friendImageView.widthAnchor.constraint(equalTo: friendImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width / 2),
            nameLabel.heightAnchor.constraint(equalTo: friendImageView.heightAnchor)
        ])
    }
}
