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
    
    lazy var stateView = interfaceBuilder.createView()
    lazy var loginTextField = interfaceBuilder.createTextField()
    lazy var passwordTextField = interfaceBuilder.createTextField()
    lazy var repeatPasswordTextField = interfaceBuilder.createTextField()
    lazy var statusAuthLabel = interfaceBuilder.createLabel()
    lazy var loginButton = interfaceBuilder.createButton()
    lazy var stateAuthButton = interfaceBuilder.createButton()
    
    weak var delegate: AuthorizationViewControllerDelegate?

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
        view.addSubviews(stateView, stateAuthButton, loginTextField, repeatPasswordTextField, passwordTextField,  statusAuthLabel, loginButton)
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
        
        loginTextField.placeholder = "Input login"
        passwordTextField.placeholder = "Input password"
        repeatPasswordTextField.placeholder = "Repeat password"
    }
    
    private func settingButton(title: String) {
        loginButton.setTitle(title, for: .normal)
        stateAuthButton.setTitle("Sign up                 Log in", for: .normal)
    }
    
    private func settingViews() {
        view.backgroundColor = .white
    }
    
    private func setupTargets() {
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


