//
//  SetupConstraint.swift
//  HandShakeProject
//
//  Created by Марк on 14.07.23.
//

import UIKit

// MARK: - AuthorizationViewController Constraint

extension AuthorizationViewController {
    
    func setupConstraints() {
        
        let heightForView = view.frame.height / 14
        
        NSLayoutConstraint.activate([
            authSegmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            authSegmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            authSegmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            authSegmentControl.heightAnchor.constraint(equalToConstant: heightForView * 0.8)
        ])
        
        NSLayoutConstraint.activate([
            loginTextField.topAnchor.constraint(equalTo: authSegmentControl.bottomAnchor, constant: 30),
            loginTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            loginTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            loginTextField.heightAnchor.constraint(equalToConstant: heightForView)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 15),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passwordTextField.heightAnchor.constraint(equalToConstant: heightForView)
        ])
        
        NSLayoutConstraint.activate([
            repeatPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            repeatPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            repeatPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            repeatPasswordTextField.heightAnchor.constraint(equalToConstant: heightForView)
        ])
        
        NSLayoutConstraint.activate([
            statusAuthLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30 + heightForView),
            statusAuthLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            statusAuthLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            statusAuthLabel.heightAnchor.constraint(equalToConstant: heightForView)
        ])
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: statusAuthLabel.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            loginButton.heightAnchor.constraint(equalToConstant: heightForView)
        ])
    }
}

// MARK: - MainTabBarViewController Constraint

extension MainTabBarViewController {
    func setupConstraints() {
        
    }
}
// MARK: - EventCreateViewController Constraint

extension EventCreateViewController {
    func setupConstraints() {
        
        let heightForView = view.frame.height / 14
        
        NSLayoutConstraint.activate([
            teamLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            teamLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            teamLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            teamLabel.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])

        NSLayoutConstraint.activate([
            chooseTeamButton.topAnchor.constraint(equalTo: teamLabel.bottomAnchor, constant: 5),
            chooseTeamButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            chooseTeamButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            chooseTeamButton.heightAnchor.constraint(equalToConstant: heightForView )
        ])
        
        NSLayoutConstraint.activate([
            namingLabel.topAnchor.constraint(equalTo: chooseTeamButton.bottomAnchor, constant: 10),
            namingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            namingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            namingLabel.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])
   
        NSLayoutConstraint.activate([
            namingTextField.topAnchor.constraint(equalTo: namingLabel.bottomAnchor, constant: 5),
            namingTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            namingTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            namingTextField.heightAnchor.constraint(equalToConstant: heightForView * 0.6)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: namingTextField.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            descriptionLabel.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])
        
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            descriptionTextView.heightAnchor.constraint(equalToConstant: heightForView * 0.8)
        ])
        
        NSLayoutConstraint.activate([
            deadlineTypeLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 10),
            deadlineTypeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            deadlineTypeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            deadlineTypeLabel.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])
        
        NSLayoutConstraint.activate([
            importanceSegmentControl.topAnchor.constraint(equalTo: deadlineTypeLabel.bottomAnchor, constant: 5),
            importanceSegmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            importanceSegmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            importanceSegmentControl.heightAnchor.constraint(equalToConstant: heightForView * 0.6)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: importanceSegmentControl.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            dateLabel.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])

        NSLayoutConstraint.activate([
            chooseDateButton.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            chooseDateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            chooseDateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            chooseDateButton.heightAnchor.constraint(equalToConstant: heightForView)
        ])
        
        NSLayoutConstraint.activate([
            executorLabel.topAnchor.constraint(equalTo: chooseDateButton.bottomAnchor, constant: 10),
            executorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            executorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            executorLabel.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])

        NSLayoutConstraint.activate([
            chooseExecutorButton.topAnchor.constraint(equalTo: executorLabel.bottomAnchor, constant: 5),
            chooseExecutorButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            chooseExecutorButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            chooseExecutorButton.heightAnchor.constraint(equalToConstant: heightForView)
        ])

        NSLayoutConstraint.activate([
            familiarizationLabel.topAnchor.constraint(equalTo: chooseExecutorButton.bottomAnchor, constant: 10),
            familiarizationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            familiarizationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            familiarizationLabel.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])

        NSLayoutConstraint.activate([
            readingListTextView.topAnchor.constraint(equalTo: familiarizationLabel.bottomAnchor, constant: 5),
            readingListTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            readingListTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            readingListTextView.heightAnchor.constraint(equalToConstant: heightForView)
        ])

        NSLayoutConstraint.activate([
            addToListButton.topAnchor.constraint(equalTo: familiarizationLabel.bottomAnchor, constant: 5),
            addToListButton.leadingAnchor.constraint(equalTo: readingListTextView.trailingAnchor, constant: 10),
            addToListButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addToListButton.heightAnchor.constraint(equalTo: addToListButton.widthAnchor)
        ])
    }
}


// MARK: - EventTableViewCell Constraint

extension EventTableViewCell{
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            teamImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            teamImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            teamImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            teamImageView.heightAnchor.constraint(equalTo: teamImageView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: teamImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: frame.width / 3),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: frame.height / 2 + 10)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: teamImageView.trailingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: teamImageView.trailingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20),
            dateLabel.heightAnchor.constraint(equalTo: descriptionLabel.heightAnchor)
        ])
    }
}

// MARK: - ChatsTableVeiwCell Constraint

extension ChatsTableVeiwCell{
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            userImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            userImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            userImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            userImageView.widthAnchor.constraint(equalTo: userImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width / 2),
            nameLabel.heightAnchor.constraint(equalTo: userImageView.heightAnchor)
        ])
    }
}

// MARK: - ChatLogController Constraint

extension ChatLogController {
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/14)
        ])

        NSLayoutConstraint.activate([
            sendButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            sendButton.widthAnchor.constraint(equalToConstant: 80),
            sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 50),
            textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
        ])
    }
}

// MARK: - ProfileViewController Constraint

extension ProfileViewController {

    func setupConstraints() {
        
        let heightForView = view.frame.height / 14

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            profileImageView.heightAnchor.constraint(equalToConstant: heightForView * 1.2),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.bottomAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 30),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            nameLabel.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            emailLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 30),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            emailLabel.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])
        
        NSLayoutConstraint.activate([
            editProfileButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            editProfileButton.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            editProfileButton.heightAnchor.constraint(equalToConstant: heightForView * 0.7),
            editProfileButton.widthAnchor.constraint(equalTo: editProfileButton.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            friendsButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            friendsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            friendsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            friendsButton.heightAnchor.constraint(equalToConstant: heightForView)
        ])
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: friendsButton.bottomAnchor, constant: 30),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            logoutButton.heightAnchor.constraint(equalToConstant: heightForView)
        ])
    }
}
