//
//  ChatLogController.swift
//  HandShakeProject
//
//  Created by Марк on 27.07.23.
//

import Foundation
import UIKit


class ChatLogController: UICollectionViewController {
    
    lazy var containerView = interfaceBuilder.createView()
    lazy var sendButton = interfaceBuilder.createButton()
    lazy var textField = interfaceBuilder.createTextField()
    lazy var separatorView = interfaceBuilder.createView()
    
    let interfaceBuilder = InterfaceBuilder()
    let chatAPI = ChatAPI.shared
    let cellId = "cellId"
    var messages: [Message]?
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
       
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        messages?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MessageCollectionViewCell else { return UICollectionViewCell() }
        let message = messages?[indexPath.row]
        cell.message = message
        return cell
    }
    
    private func setUI() {
        bindViewModel()
        setSubviews()
        setupConstraints()
        settingTextField()
        settingTextLabel()
        settingButton()
        setupTargets()
    }
    
    private func setSubviews() {
        collectionView.register(MessageCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubviews(containerView)
        view.addSubviews(textField, sendButton)
    }
    
    private func settingTextField() {
        textField.delegate = self
        
        textField.placeholder = "Input text..."
    }
    
    private func settingTextLabel() {
        
    }
    
    private func settingButton() {
        sendButton.setTitle("Send", for: .normal)
        
    }
    
    private func bindViewModel() {

    }
    
    private func setInputComponents() {
        
    }
    
    
    
    private func loadMessages() {
//        if user.uid == messages.
    }
    
    
    
    
    
    
    
    private func sendText() {
        guard let text = textField.text,
        let uid = user?.uid else { return }
            chatAPI.sendMessage(text: text, toId: uid, completion: { _ in
        })
    }
    
    private func setupTargets() {
        sendButton.addTarget(self, action: #selector(sendAction(_:)), for: .touchUpInside)
    }
}

extension ChatLogController {
    @objc func sendAction(_ sender: Any) {
        sendText()
    }
}

extension ChatLogController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ChatLogController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height / 14)
    }
}

