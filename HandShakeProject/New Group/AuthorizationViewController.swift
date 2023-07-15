//
//  ViewController.swift
//  HandShakeProject
//
//  Created by Марк on 14.07.23.
//

import UIKit


class AuthorizationViewController: UIViewController {
    
    lazy var stateView = interfaceBuilder.createView()
    lazy var loginTextField = interfaceBuilder.createTextField()
    lazy var passwordTextField = interfaceBuilder.createTextField()
    lazy var repeatPasswordTextField = interfaceBuilder.createTextField()
    lazy var statusAuthLabel = interfaceBuilder.createLabel()
    lazy var loginButton = interfaceBuilder.createButton()
    lazy var stateAuthButton = interfaceBuilder.createButton()
    
    let interfaceBuilder = InterfaceBuilder()
    var authViewModel = AuthViewModel()
    
    let authState = ["Sign up", "Log in"]
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    
    
    var signup: Bool = true {
        willSet {
            if newValue {
                settingButton(title: authState.first ?? "")
                repeatPasswordTextField.isHidden = false
            } else {
                settingButton(title: authState.last ?? "")
                repeatPasswordTextField.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
        
    }
    
    func bindViewModel() {
        authViewModel.statusText.bind({ (statusText) in
            DispatchQueue.main.async {
                self.statusAuthLabel.text = statusText
            }
        })
    }
    func setupTargets() {
        loginButton.addTarget(self, action: #selector(loginAction(_:)), for: .touchUpInside)
        stateAuthButton.addTarget(self, action: #selector(changeAuthState(_:)), for: .touchUpInside)
    }
}

// MARK: - Action

private extension AuthorizationViewController {
    @objc
    private func loginAction(_ sender: Any) {
        if let login = loginTextField.text,
           let password = passwordTextField.text,
           let rPassword = repeatPasswordTextField.text {
            authViewModel.userButtonPressed(login: login, password: password, repeatPassword: rPassword, state: signup, completion: { [weak self](bool) in
                if bool {
                    let mVC = MainTapBarViewController()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        mVC.modalPresentationStyle = .fullScreen
                        self?.present(mVC, animated: true)
                        
                        AuthorizationViewController().dismiss(animated: true, completion: nil)
                    })
                }
            })
        }
    }
    
    
    @objc
    private func changeAuthState(_ sender: Any) {
        animateView()
        signup = !signup
        view.layoutIfNeeded()
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


