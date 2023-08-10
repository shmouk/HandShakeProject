//
//  EventCreateViewController.swift
//  HandShakeProject
//
//  Created by Марк on 19.07.23.
//

import UIKit

class EventCreateViewController: UIViewController {
    
    lazy var namingTextField = interfaceBuilder.createTextField()
    lazy var descriptionTextView = interfaceBuilder.createTextView()
    lazy var readingListTextView = interfaceBuilder.createTextView()
    
    lazy var teamLabel = interfaceBuilder.createTitleLabel()
    lazy var namingLabel = interfaceBuilder.createTitleLabel()
    lazy var deadlineTypeLabel = interfaceBuilder.createTitleLabel()
    lazy var dateLabel = interfaceBuilder.createTitleLabel()
    lazy var descriptionLabel = interfaceBuilder.createTitleLabel()
    lazy var executorLabel = interfaceBuilder.createTitleLabel()
    lazy var familiarizationLabel = interfaceBuilder.createTitleLabel()
    
    lazy var chooseTeamButton = interfaceBuilder.createButton()
    lazy var chooseExecutorButton = interfaceBuilder.createButton()
    
    lazy var addToListButton = interfaceBuilder.createButton()
    lazy var chooseDateButton = interfaceBuilder.createButton()
    lazy var importanceSegmentControl = interfaceBuilder.createSegmentControl(items: deadlineState)
    
    let interfaceBuilder = InterfaceBuilder()
    
    private let deadlineState = ["No time", "Low", "Medium", "High"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
    }
    
    private func bindViewModel() {
        
    }
    
    private func setUI() {
        setSubviews()
        setSettings()
        setupConstraints()
        setupTargets()
        updateNavItem()
    }
    
    private func setSubviews() {
        view.addSubviews(namingTextField, chooseTeamButton, chooseExecutorButton, descriptionTextView, teamLabel, namingLabel,
                         deadlineTypeLabel, dateLabel, descriptionLabel, executorLabel, familiarizationLabel,
                         readingListTextView, addToListButton, chooseDateButton, importanceSegmentControl)
    }
    
    private func setSettings() {
        settingViews()
        settingTextField()
        settingButton()
        settingTextLabel()
    }
    
    private func settingTextField() {
        namingTextField.delegate = self
        descriptionTextView.delegate = self
        readingListTextView.isEditable = false
        namingTextField.placeholder = "Input name event"
    }
    
    private func settingTextLabel() {
        teamLabel.text = "Choose team:"
        namingLabel.text = "Name event:"
        deadlineTypeLabel.text = "Choose deadline type:"
        dateLabel.text = "Choose date:"
        descriptionLabel.text = "Description:"
        executorLabel.text = "Choose executor:"
        familiarizationLabel.text = "Choose reader:"
    }
    
    private func settingButton() {
        addToListButton.setImage(.add, for: .normal)
        chooseTeamButton.setTitle("Choose team", for: .normal)
        chooseExecutorButton.setTitle("Choose executor", for: .normal)
        chooseDateButton.setTitle("Choose date", for: .normal)
    }
    
    private func settingViews() {
        view.backgroundColor = .white
    }
    
    private func setupTargets() {
        importanceSegmentControl.addTarget(self, action: #selector(changeDeadlineState(_:)), for: .valueChanged)
        addToListButton.addTarget(self, action: #selector(addAction(_:)), for: .touchUpInside)
        chooseDateButton.addTarget(self, action: #selector(changeDateAction(_:)), for: .touchUpInside)
    }
    
    private func updateNavItem() {
        
        let navItem = UINavigationItem(title: "Create event")
        let rightButton = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(createEvent))
        navItem.rightBarButtonItem = rightButton
        self.navigationItem.setRightBarButton(rightButton, animated: false)
        self.navigationItem.title = navItem.title
    }
}

// MARK: - Action

private extension EventCreateViewController {
    
    @objc
    private func createEvent(_ sender: Any) {
        print("create")
    }
    @objc
    private func addAction(_ sender: Any) {
    }
    
    @objc
    private func changeDeadlineState(_ sender: Any) {
    }
    @objc
    private func changeDateAction(_ sender: Any) {
    }
}

extension EventCreateViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        namingTextField.resignFirstResponder()
        return true
    }
}

extension EventCreateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        descriptionTextView.text = nil
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let currentText = textView.text, let range = Range(range, in: currentText) else { return false }
        let newText = currentText.replacingCharacters(in: range, with: text)
        if newText.count > 100 {
            return false
        }
        if text == "\n" {
            descriptionTextView.resignFirstResponder()
            return false
        }
        return true
    }
}

