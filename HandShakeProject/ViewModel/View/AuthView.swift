//
//  AuthView.swift
//  HandShakeProject
//
//  Created by Марк on 14.07.23.
//

import UIKit

extension AuthorizationViewController {
    
    func setUI() {
        setSubviews()
        setSettings()
        setupConstraints()
        setupTargets()
    }
    
    func setSubviews() {
        view.addSubviews(stateView, stateAuthButton, loginTextField, repeatPasswordTextField, passwordTextField,  statusAuthLabel, loginButton)
    }
    
    func setSettings() {
        settingViews()
        settingTextField()
        settingButton(title: "Sign up")
    }
    
    func settingTextField() {
        loginTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
        
        loginTextField.placeholder = "Input login"
        passwordTextField.placeholder = "Input password"
        repeatPasswordTextField.placeholder = "Repeat password"
    }
    
    func settingButton(title: String) {
        loginButton.setTitle(title, for: .normal)
        stateAuthButton.setTitle("Sign up                 Log in", for: .normal)
    }
    
    func settingViews() {
        view.backgroundColor = .white
    }
}

