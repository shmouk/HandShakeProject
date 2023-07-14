//
//  ViewController.swift
//  HandShakeProject
//
//  Created by Марк on 14.07.23.
//

import UIKit

class AuthorizationViewController: UIViewController {
    
    lazy var loginTextField = interfaceBuilder.createTextField()
    lazy var passwordTextField = interfaceBuilder.createTextField()
    lazy var statusAuthLabel = interfaceBuilder.createLabel()
    lazy var loginButton = interfaceBuilder.createButton()
    
    let interfaceBuilder = InterfaceBuilder()
    
    var authViewModel = AuthViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
        
    }
    
    func setUI() {
        setSubviews()
        setSettings()
        setupConstraints()
        setupTargets()
    }
    
    func setSubviews() {
        view.addSubviews(loginTextField, passwordTextField, statusAuthLabel, loginButton)
    }
    
    func setSettings() {
        settingViews()
        settingTextField()
        settingButton()
    }
    
    func settingTextField() {
        loginTextField.placeholder = "Input login"
        passwordTextField.placeholder = "Input password"
    }
    
    func settingButton() {
        loginButton.setTitle("Log in", for: .normal)
    }
    
    func settingViews() {
        view.backgroundColor = .white
    }
    
    func bindViewModel() {
        authViewModel.statusText.bind({ (statusText) in
            DispatchQueue.main.async {
                self.statusAuthLabel.text = statusText
            }
        })
    }
    private func setupTargets() {
        loginButton.addTarget(self, action: #selector(loginAction(_:)), for: .touchUpInside)
    }
}

// MARK: - Action

private extension AuthorizationViewController {
    @objc
    private func loginAction(_ sender: Any) {
        if let loginText = loginTextField.text, let passwordText = passwordTextField.text {
            print(loginText, passwordText)
            authViewModel.userButtonPressed(login: loginText, password: passwordText)
        }
    }
}

