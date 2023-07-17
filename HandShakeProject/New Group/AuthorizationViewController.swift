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
    lazy var statusAuthLabel = interfaceBuilder.createLabel()
    lazy var loginButton = interfaceBuilder.createButton()
    lazy var authSegmentControl = interfaceBuilder.createSegmentControl(items: authState)
    
    weak var delegate: AuthorizationViewControllerDelegate?

    let interfaceBuilder = InterfaceBuilder()
    var authViewModel = AuthViewModel()
    
    let authState = ["Sign up", "Log in"]
    
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
    
    func login() {
           delegate?.didLogin()
       }

    private func bindViewModel() {
        authViewModel.statusText.bind({ (statusText) in
            DispatchQueue.main.async {
                self.statusAuthLabel.text = statusText
            }
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
        view.backgroundColor = .white
    }
    
    private func setupTargets() {
        authSegmentControl.addTarget(self, action: #selector(changeAuthState(_:)), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(loginAction(_:)), for: .touchUpInside)
    }
}

// MARK: - Action

private extension AuthorizationViewController {
    
    @objc
    private func loginAction(_ sender: Any) {
        
        if let login = loginTextField.text,
           let password = passwordTextField.text,
           let rPassword = repeatPasswordTextField.text {
            
            authViewModel.userLoginAction(login: login, password: password, repeatPassword: rPassword, state: signup, completion: { [weak self](bool) in
                
                if bool {
                    let mVC = MainTabBarViewController()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        mVC.modalPresentationStyle = .fullScreen
                        self?.navigationController?.pushViewController(mVC, animated: true)
//                        self?.present(mVC, animated: true)
                        
                    })
                }
            })
        }
    }
    
    @objc
    private func changeAuthState(_ sender: Any) {
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


