import UIKit

class ProfileViewController: UIViewController {
    private let navigationBarManager = NavigationBarManager()
    private let authViewModel = AuthViewModel()

    let profileViewModel = ProfileViewModel()
    
    var activityIndicator = InterfaceBuilder.createActivityIndicator()
    var logoutButton = InterfaceBuilder.createButton()
    var editProfileButton = InterfaceBuilder.createButton()
    var nameLabel = InterfaceBuilder.createTitleLabel()
    var emailLabel = InterfaceBuilder.createDescriptionLabel()
    var profileImageView = InterfaceBuilder.createImageView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("4")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        loadData()
        bindViewModel()
    }
    
    private func setUI() {
        setupNavBarManager()
        setSubviews()
        settingButton()
        settingImage()
        setupConstraints()
        setupTargets()
    }
    
    private func setSubviews() {
        view.addSubviews(activityIndicator, profileImageView, editProfileButton, emailLabel, nameLabel, logoutButton)
        view.backgroundColor = .colorForView()
    }

    func loadData() {
        activityIndicator.startAnimating()
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            self.profileViewModel.fetchUser() { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    private func bindViewModel() {
        profileViewModel.currentUser.bind { [weak self] user in
            guard let self = self else { return }
            nameLabel.text = user.name
            emailLabel.text = user.email
            profileImageView.image = user.image
        }
    }
    
    private func settingImage() {
        editProfileButton.setImage(UIImage(systemName: "pencil.line"), for: .normal)
    }
    
    private func settingButton() {
        logoutButton.setTitle("Logout", for: .normal)
    }
    
    private func setupNavBarManager() {
        navigationBarManager.delegate = self
        navigationBarManager.updateNavigationBar(for: self, isLeftButtonNeeded: false)
    }
    
    private func setupTargets() {
        editProfileButton.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutAction(_:)), for: .touchUpInside)
    }
}

// MARK: - Action

private extension ProfileViewController {
    
    @objc
    private func editProfile(_ sender: Any) {
        profileViewModel.requestPhotoLibraryAccess { [weak self] isAccess in
            guard let self = self else { return }
            if isAccess {
                DispatchQueue.main.async { [self] in
                    self.selectProfileImageView()
                }
            } else {
                AlertManager.showAlert(title: "Failure", message: "You have not granted access to the gallery.", viewController: self)
            }
        }
    }
    
    @objc
    private func logoutAction(_ sender: Any) {
        authViewModel.userLogoutAction()
    }
}

extension ProfileViewController: NavigationBarManagerDelegate {
    func didTapRightButton() {
    }
    
    func didTapAddButton() {
    }
}
