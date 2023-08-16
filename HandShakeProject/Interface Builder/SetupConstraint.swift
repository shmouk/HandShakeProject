import UIKit

// MARK: - AuthorizationViewController Constraint

extension AuthorizationViewController {
    
    func setupConstraints() {
        
        let heightForView = view.frame.height / 14
        
        NSLayoutConstraint.activate([
            authSegmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            authSegmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            authSegmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            authSegmentControl.heightAnchor.constraint(equalToConstant: heightForView * 0.8)
        ])
        
        NSLayoutConstraint.activate([
            loginTextField.topAnchor.constraint(equalTo: authSegmentControl.bottomAnchor, constant: 30),
            loginTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginTextField.heightAnchor.constraint(equalToConstant: heightForView)
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 15),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: heightForView)
        ])
        
        NSLayoutConstraint.activate([
            repeatPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            repeatPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            repeatPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            repeatPasswordTextField.heightAnchor.constraint(equalToConstant: heightForView)
        ])
        
        NSLayoutConstraint.activate([
            statusAuthLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30 + heightForView),
            statusAuthLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusAuthLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statusAuthLabel.heightAnchor.constraint(equalToConstant: heightForView)
        ])
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: statusAuthLabel.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
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
            teamLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            teamLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            teamLabel.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])

        NSLayoutConstraint.activate([
            chooseTeamButton.topAnchor.constraint(equalTo: teamLabel.bottomAnchor, constant: 5),
            chooseTeamButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chooseTeamButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chooseTeamButton.heightAnchor.constraint(equalToConstant: heightForView )
        ])
        
        NSLayoutConstraint.activate([
            namingLabel.topAnchor.constraint(equalTo: chooseTeamButton.bottomAnchor, constant: 10),
            namingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            namingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            namingLabel.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])
   
        NSLayoutConstraint.activate([
            namingTextField.topAnchor.constraint(equalTo: namingLabel.bottomAnchor, constant: 5),
            namingTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            namingTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            namingTextField.heightAnchor.constraint(equalToConstant: heightForView * 0.6)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: namingTextField.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionLabel.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])
        
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: heightForView * 0.8)
        ])
        
        NSLayoutConstraint.activate([
            deadlineTypeLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 10),
            deadlineTypeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            deadlineTypeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            deadlineTypeLabel.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])
        
        NSLayoutConstraint.activate([
            importanceSegmentControl.topAnchor.constraint(equalTo: deadlineTypeLabel.bottomAnchor, constant: 5),
            importanceSegmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            importanceSegmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            importanceSegmentControl.heightAnchor.constraint(equalToConstant: heightForView * 0.6)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: importanceSegmentControl.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dateLabel.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])

        NSLayoutConstraint.activate([
            chooseDateButton.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            chooseDateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chooseDateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chooseDateButton.heightAnchor.constraint(equalToConstant: heightForView)
        ])
        
        NSLayoutConstraint.activate([
            executorLabel.topAnchor.constraint(equalTo: chooseDateButton.bottomAnchor, constant: 10),
            executorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            executorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            executorLabel.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])

        NSLayoutConstraint.activate([
            chooseExecutorButton.topAnchor.constraint(equalTo: executorLabel.bottomAnchor, constant: 5),
            chooseExecutorButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chooseExecutorButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chooseExecutorButton.heightAnchor.constraint(equalToConstant: heightForView)
        ])

        NSLayoutConstraint.activate([
            familiarizationLabel.topAnchor.constraint(equalTo: chooseExecutorButton.bottomAnchor, constant: 10),
            familiarizationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            familiarizationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            familiarizationLabel.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])

        NSLayoutConstraint.activate([
            readingListTextView.topAnchor.constraint(equalTo: familiarizationLabel.bottomAnchor, constant: 5),
            readingListTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readingListTextView.trailingAnchor.constraint(equalTo: addToListButton.leadingAnchor, constant: -10),
            readingListTextView.heightAnchor.constraint(equalToConstant: heightForView)
        ])

        NSLayoutConstraint.activate([
            addToListButton.topAnchor.constraint(equalTo: familiarizationLabel.bottomAnchor, constant: 5),
            addToListButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addToListButton.heightAnchor.constraint(equalToConstant: heightForView),
            addToListButton.widthAnchor.constraint(equalTo: addToListButton.heightAnchor)

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

// MARK: - TeamViewController

extension TeamViewController {
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - TeamInfoViewController Constraint

extension TeamInfoViewController {

    func setupConstraints() {
        
        let heightForView = view.frame.height / 14

        NSLayoutConstraint.activate([
            teamImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            teamImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            teamImageView.heightAnchor.constraint(equalToConstant: heightForView * 1.2),
            teamImageView.widthAnchor.constraint(equalTo: teamImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: teamImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: teamImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: editTeamButton.leadingAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])
        
        NSLayoutConstraint.activate([
            creatorID.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            creatorID.leadingAnchor.constraint(equalTo: teamImageView.trailingAnchor, constant: 10),
            creatorID.trailingAnchor.constraint(equalTo: editTeamButton.leadingAnchor, constant: -10),
            creatorID.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])
        
        NSLayoutConstraint.activate([
            editTeamButton.centerYAnchor.constraint(equalTo: teamImageView.centerYAnchor),
            editTeamButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            editTeamButton.heightAnchor.constraint(equalToConstant: heightForView * 0.7),
            editTeamButton.widthAnchor.constraint(equalTo: editTeamButton.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userListButton.topAnchor.constraint(equalTo: teamImageView.bottomAnchor, constant: 10),
            userListButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userListButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userListButton.heightAnchor.constraint(equalToConstant: heightForView)
        ])
    }
}

// MARK: - TeamCeateViewController Constraint

extension TeamCeateViewController {
    func setupConstraints() {
        
        let heightForView = view.frame.height / 14
        
        NSLayoutConstraint.activate([
            teamLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            teamLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            teamLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            teamLabel.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])
        
        NSLayoutConstraint.activate([
            namingTextField.topAnchor.constraint(equalTo: teamLabel.bottomAnchor, constant: 5),
            namingTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            namingTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            namingTextField.heightAnchor.constraint(equalToConstant: heightForView * 0.8)
        ])
    }
}

// MARK: - AddUserViewController Constraint

extension AddUserViewController {
    func setupConstraints() {
        
        let heightForView = view.frame.height / 14
        
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userNameLabel.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])
        
        NSLayoutConstraint.activate([
            namingTextField.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
            namingTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            namingTextField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -10),
            namingTextField.heightAnchor.constraint(equalToConstant: heightForView * 0.8)
        ])
        
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchButton.heightAnchor.constraint(equalToConstant: heightForView * 0.8),
            searchButton.widthAnchor.constraint(equalTo: searchButton.heightAnchor, multiplier: 1.6)
        ])
        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: namingTextField.bottomAnchor, constant: 10),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusLabel.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - TeamTableViewCell Constraint

extension TeamTableViewCell {
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            teamImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            teamImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            teamImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            teamImageView.widthAnchor.constraint(equalTo: teamImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            teamNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            teamNameLabel.leadingAnchor.constraint(equalTo: teamImageView.trailingAnchor, constant: 20),
            teamNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width / 2),
            teamNameLabel.heightAnchor.constraint(equalTo: teamImageView.heightAnchor)
        ])
    }
}

// MARK: - UsersListTableViewController Constraint

extension UsersListTableViewController {
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: view.frame.height / 14)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


// MARK: - ChatViewController Constraint

extension ChatViewController {
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
// MARK: - UsersTableViewCell Constraint

extension UsersTableViewCell {
    
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

// MARK: - MessageTableViewCell Constraint

extension MessageTableViewCell {
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            userImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            userImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            userImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            userImageView.widthAnchor.constraint(equalTo: userImageView.heightAnchor)
        ])
             
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            nameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/2)
        ])
        
        NSLayoutConstraint.activate([
            messageTextLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            messageTextLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            messageTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            messageTextLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/2)
        ])
         
        NSLayoutConstraint.activate([
            timeTextLabel.topAnchor.constraint(equalTo: topAnchor),
            timeTextLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            timeTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            timeTextLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/2)
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

// MARK: - MessageCollectionViewCell Constraint

extension MessageCollectionViewCell {
    
    func setupConstraints() {
        guard let check = isMessegeForUser else { return }
        
        messageTextView.removeConstraints(messageTextView.constraints)
        timeTextLabel.removeConstraints(messageTextView.constraints)
        
        NSLayoutConstraint.activate([
            messageTextView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            messageTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        if check {
            NSLayoutConstraint.activate([
                messageTextView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2),
                messageTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
            ])
        } else {
            NSLayoutConstraint.activate([
                messageTextView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/2),
                messageTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
            ])
        }
        
        NSLayoutConstraint.activate([
            timeTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            timeTextLabel.leadingAnchor.constraint(equalTo: messageTextView.trailingAnchor, constant: -50),
            timeTextLabel.trailingAnchor.constraint(equalTo: messageTextView.trailingAnchor),
            timeTextLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/2)
        ])
    }
}

    
// MARK: - ProfileViewController Constraint

extension ProfileViewController {

    func setupConstraints() {
        
        let heightForView = view.frame.height / 14

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileImageView.heightAnchor.constraint(equalToConstant: heightForView * 1.2),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.bottomAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            nameLabel.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])
        
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            emailLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            emailLabel.heightAnchor.constraint(equalToConstant: heightForView / 2)
        ])
        
        NSLayoutConstraint.activate([
            editProfileButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            editProfileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            editProfileButton.heightAnchor.constraint(equalToConstant: heightForView * 0.7),
            editProfileButton.widthAnchor.constraint(equalTo: editProfileButton.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            friendsButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            friendsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            friendsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            friendsButton.heightAnchor.constraint(equalToConstant: heightForView)
        ])
        
        NSLayoutConstraint.activate([
            logoutButton.topAnchor.constraint(equalTo: friendsButton.bottomAnchor, constant: 30),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logoutButton.heightAnchor.constraint(equalToConstant: heightForView)
        ])
    }
}
