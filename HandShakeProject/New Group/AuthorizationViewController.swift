//
//  ViewController.swift
//  HandShakeProject
//
//  Created by Марк on 14.07.23.
//

import UIKit

protocol AuthorizationViewControllerDelegate: AnyObject {
    func didLogin()
}

class AuthorizationViewController: UIViewController {
    
    lazy var loginTextField = interfaceBuilder.createTextField()
    lazy var passwordTextField = interfaceBuilder.createTextField()
    lazy var repeatPasswordTextField = interfaceBuilder.createTextField()
    lazy var statusAuthLabel = interfaceBuilder.createTitleLabel()
    lazy var loginButton = interfaceBuilder.createButton()
    lazy var authSegmentControl = interfaceBuilder.createSegmentControl(items: authState)
    
    weak var delegate: AuthorizationViewControllerDelegate?

    let interfaceBuilder = InterfaceBuilder()
    var authViewModel = AuthViewModel()
    
    let authState = ["Sign up", "Log in"]
    
    var isSignup = true
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
    }
    
//    private func login() {
//           delegate?.didLogin()
//       }

    private func bindViewModel() {
        authViewModel.statusText.bind({ [self](statusText) in
                statusAuthLabel.text = statusText
        })
        authViewModel.signupBindable.bind({ [self](signup) in
                isSignup = signup
                settingButton(title: signup ? authState.first ?? "" : authState.last ?? "")
                repeatPasswordTextField.isHidden = !signup
        })
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
                let rPassword = repeatPasswordTextField.text else {
            statusAuthLabel.text = "Error: Empty fields"
            return
        }
        
        authViewModel.userLoginAction(email: email, password: password, repeatPassword: rPassword, state: isSignup) { [weak self] (success) in
            guard success else { return }
            
            let mVC = MainTabBarViewController()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                mVC.modalPresentationStyle = .fullScreen
                self?.navigationController?.pushViewController(mVC, animated: true)
            })
        }
    }

    @objc
    private func changeAuthState(_ sender: Any) {
        authViewModel.changeAuthState()
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


