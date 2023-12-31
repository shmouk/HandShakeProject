import UIKit

class TeamCeateViewController: UIViewController {
    private let teamViewModel = TeamViewModel()
    
    var namingTextField = InterfaceBuilder.createTextField()
    var teamLabel = InterfaceBuilder.createTitleLabel()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        KeyboardNotificationManager.hideKeyboard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        setSubviews()
        setSettings()
        setupConstraints()
        updateNavItem()
    }
    
    private func setSettings() {
        settingTextField()
        settingTextLabel()
    }
    
    private func settingTextField() {
        namingTextField.delegate = self
        namingTextField.placeholder = "Name..."
    }
    
    private func settingTextLabel() {
        teamLabel.text = "Input Team name:"
    }
    private func setSubviews() {
        view.addSubviews(teamLabel, namingTextField)
        view.backgroundColor = .colorForView()
    }
    
    private func updateNavItem() {
        let navItem = UINavigationItem(title: "Create Team")
        let rightButton = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createTeamAction))
        navItem.rightBarButtonItem = rightButton
        self.navigationItem.setRightBarButton(rightButton, animated: false)
        self.navigationItem.title = navItem.title
        tabBarController?.tabBar.isHidden = true
    }
    
    private func createTeam() {
        guard let text = namingTextField.text else { return }
        teamViewModel.createTeam(text)
        navigationController?.popToRootViewController(animated: true)
    }
}

private extension TeamCeateViewController {
    
    @objc
    private func createTeamAction(_ sender: Any) {
        AlertManager.showConfirmationAlert(title: "Create Team", message: "Are you sure you want to create an team and it doesn't need to be changed?", viewController: self) {
            self.createTeam()
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension TeamCeateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        namingTextField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = namingTextField.text else { return true }
        
        let newLength = text.count + string.count - range.length
        
        return newLength <= 15
    }
}
