import UIKit
import FirebaseAuth

protocol AuthorizationViewControllerDelegate: AnyObject {
    func didLogin()
}

class AuthorizationViewController: UIViewController {
    private let authViewModel = AuthViewModel()
    
    weak var delegate: AuthorizationViewControllerDelegate?
    var loginTextField = InterfaceBuilder.createTextField()
    var passwordTextField = InterfaceBuilder.createTextField()
    var showHideButton = InterfaceBuilder.createButton()
    var repeatPasswordTextField = InterfaceBuilder.createTextField()
    var statusAuthLabel = InterfaceBuilder.createTitleLabel()
    var loginButton = InterfaceBuilder.createButton()
    lazy var authSegmentControl = InterfaceBuilder.createSegmentControl(items: authState)
    
    private let authState = ["Sign up", "Log in"]
    private var isSignup = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        authViewModel.userLogoutAction()
        setUI()
        bindViewModel()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hideLoadingView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        KeyboardNotificationManager.hideKeyboard()
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
                
            case .failure(let error):
                print(error.localizedDescription)
                self.navigationController?.popToRootViewController(animated: false)
            }
        }
        authViewModel.loadingViewSwitcher.bind { [weak self] isSwitch in
            guard let self = self else { return }
            self.showLoadingView()
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
        passwordTextField.addSubview(showHideButton)
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
        statusAuthLabel.textAlignment = .center
        statusAuthLabel.numberOfLines = 2
    }
    
    private func settingButton(title: String) {
        loginButton.setTitle(title, for: .normal)
        showHideButton.setImage(UIImage(systemName: "eye"), for: .normal)
        showHideButton.backgroundColor = .clear
    }
    
    private func settingViews() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
    }
    
    private func setupTargets() {
        showHideButton.addTarget(self, action: #selector(showHideButtonTouchDown), for: .touchDown)
        showHideButton.addTarget(self, action: #selector(showHideButtonTouchUpInside), for: .touchUpInside)
        showHideButton.addTarget(self, action: #selector(showHideButtonTouchUpOutside), for: .touchUpOutside)
        authSegmentControl.addTarget(self, action: #selector(changeAuthState(_:)), for: .valueChanged)
        loginButton.addTarget(self, action: #selector(loginAction(_:)), for: .touchUpInside)
    }
}

// MARK: - Action

private extension AuthorizationViewController {
    @objc
    private func loginAction(_ sender: Any) {
        KeyboardNotificationManager.hideKeyboard()
        guard let email = loginTextField.text,
              let password = passwordTextField.text,
              let rPassword = repeatPasswordTextField.text else { return }
        
        authViewModel.userLoginAction(email: email, password: password, repeatPassword: rPassword)
    }
    
    @objc
    private func changeAuthState(_ sender: Any) {
        authViewModel.toggleAuthState()
        passwordTextField.text = ""
        repeatPasswordTextField.text = ""
    }
    
    @objc
    private func showHideButtonTouchDown() {
        passwordTextField.isSecureTextEntry = false
        repeatPasswordTextField.isSecureTextEntry = false
    }
    
    @objc
    private func showHideButtonTouchUpInside() {
        passwordTextField.isSecureTextEntry = true
        repeatPasswordTextField.isSecureTextEntry = true
    }
    
    @objc
    private func showHideButtonTouchUpOutside() {
        passwordTextField.isSecureTextEntry = true
        repeatPasswordTextField.isSecureTextEntry = true
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
