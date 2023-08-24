//
//  ViewController.swift
//  HandShakeProject
//
//  Created by Марк on 14.07.23.
//

import UIKit
import FirebaseAuth

protocol AuthorizationViewControllerDelegate: AnyObject {
    func didLogin()
}

class AuthorizationViewController: UIViewController {
    private let interfaceBuilder = InterfaceBuilder()
    private let authViewModel = AuthViewModel()
    
    weak var delegate: AuthorizationViewControllerDelegate?
    
    lazy var loginTextField = interfaceBuilder.createTextField()
    lazy var passwordTextField = interfaceBuilder.createTextField()
    lazy var repeatPasswordTextField = interfaceBuilder.createTextField()
    lazy var statusAuthLabel = interfaceBuilder.createTitleLabel()
    lazy var loginButton = interfaceBuilder.createButton()
    lazy var authSegmentControl = interfaceBuilder.createSegmentControl(items: authState)

    private let authState = ["Sign up", "Log in"]
    private var isSignup = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
    }

    private func bindViewModel() {
        authViewModel.statusText.bind({ [weak self](statusText) in
            guard let self = self else { return }
            self.statusAuthLabel.text = statusText
            self.statusAuthLabel.textColor = .systemRed
        })
        authViewModel.isSigningUp.bind({ [weak self](signup) in
            guard let self = self else { return }
            self.isSignup = signup
            self.settingButton(title: signup ? authState[0] : authState[1])
            self.repeatPasswordTextField.isHidden = !signup
        })
        
        authViewModel.authStateListener { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                delegate?.didLogin()
                AlertManager.showAlert(title: "Success", message: "Account successfully login", viewController: self)

            case .failure(let error):
                self.navigationController?.popToRootViewController(animated: false)
                AlertManager.showAlert(title: "Failure", message: "Account logout \(error)", viewController: self)
            }
        }
    }
    
    private func setUI() {
        setSubviews()
        setSettings()
        setupConstraints()
        setupTargets()
    }
    
    private func setSubviews() {
        view.addSubviews(authSegmentControl, loginTextField, repeatPasswordTextField, passwordTextField,  statusAuthLabel, loginButton)
    }
    
    private func setSettings() {
        settingViews()
        settingTextField()
        settingButton(title: "Sign up")
    }
    
    private func settingTextField() {
        loginTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
        
        passwordTextField.isSecureTextEntry = true
        repeatPasswordTextField.isSecureTextEntry = true

        loginTextField.placeholder = "Input login (email)"
        passwordTextField.placeholder = "Input password"
        repeatPasswordTextField.placeholder = "Repeat password"
    }
    
    private func settingButton(title: String) {
        loginButton.setTitle(title, for: .normal)
    }
    
    private func settingViews() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
    }
    
    private func setupTargets() {
        authSegmentControl.addTarget(self, action: #selector(changeAuthState(_:)), for: .valueChanged)
        loginButton.addTarget(self, action: #selector(loginAction(_:)), for: .touchUpInside)
    }
}

// MARK: - Action

private extension AuthorizationViewController {
    
    @objc private func loginAction(_ sender: Any) {
        guard let email = loginTextField.text,
                let password = passwordTextField.text,
                let rPassword = repeatPasswordTextField.text else { return }
        
        authViewModel.userLoginAction(email: email, password: password, repeatPassword: rPassword)
    }

    @objc
    private func changeAuthState(_ sender: Any) {
        authViewModel.toggleAuthState()
    }
}

extension AuthorizationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextField.resignFirstResponder()
        loginTextField.resignFirstResponder()
        repeatPasswordTextField.resignFirstResponder()
        return true
    }
}


