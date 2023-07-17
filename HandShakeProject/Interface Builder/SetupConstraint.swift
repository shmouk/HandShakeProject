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
        
        NSLayoutConstraint.activate([
            stateAuthButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            stateAuthButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stateAuthButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stateAuthButton.heightAnchor.constraint(equalToConstant: view.frame.height / 12)
        ])
        
        leadingConstraint = stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        trailingConstraint = stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.frame.width / 2)
        
        NSLayoutConstraint.activate([
            stateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            leadingConstraint,
            trailingConstraint,
            stateView.heightAnchor.constraint(equalToConstant: view.frame.height / 12)
        ])
        
        NSLayoutConstraint.activate([
            loginTextField.topAnchor.constraint(equalTo: stateAuthButton.bottomAnchor, constant: 30),
            loginTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            loginTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            loginTextField.heightAnchor.constraint(equalToConstant: view.frame.height / 14)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 30),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passwordTextField.heightAnchor.constraint(equalToConstant: view.frame.height / 14)
        ])
        
        NSLayoutConstraint.activate([
            repeatPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            repeatPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            repeatPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            repeatPasswordTextField.heightAnchor.constraint(equalToConstant: view.frame.height / 14)
        ])
        
        NSLayoutConstraint.activate([
            statusAuthLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30 + view.frame.height / 14),
            statusAuthLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            statusAuthLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            statusAuthLabel.heightAnchor.constraint(equalToConstant: view.frame.height / 14)
        ])

        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: statusAuthLabel.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            loginButton.heightAnchor.constraint(equalToConstant: view.frame.height / 8)
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
