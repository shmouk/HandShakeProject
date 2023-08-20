//
//  TeamCeateViewController.swift
//  HandShakeProject
//
//  Created by Марк on 11.08.23.
//

import UIKit

class TeamCeateViewController: UIViewController {
    private let interfaceBuilder = InterfaceBuilder()
    private let teamViewModel = TeamViewModel()
    
    lazy var namingTextField = interfaceBuilder.createTextField()
    lazy var teamLabel = interfaceBuilder.createTitleLabel()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        view.backgroundColor = .white
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
        createTeam()
    }
}

extension TeamCeateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        namingTextField.resignFirstResponder()
        return true
    }
}
