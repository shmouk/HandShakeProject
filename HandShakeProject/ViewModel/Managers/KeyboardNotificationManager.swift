//
//  Observer.swift
//  HandShakeProject
//
//  Created by Марк on 17.08.23.
//

import UIKit

class KeyboardNotificationManager {
    
    private weak var view: UIView?
    
    init(view: UIView) {
        self.view = view
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { [weak self] (notification) in
            self?.keyboardWillShow(notification: notification)
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { [weak self] (notification) in
            self?.keyboardWillHide(notification: notification)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let view = self.view else {
                return
        }
        
        let convertedKeyboardFrame = view.convert(keyboardFrame, from: UIScreen.main.coordinateSpace)
        
        let intersection = convertedKeyboardFrame.intersection(view.bounds)
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.0
        
        UIView.animate(withDuration: duration) {
            view.transform = CGAffineTransform(translationX: 0, y: -intersection.size.height)
        }
    }
    
    private func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let view = self.view else {
                return
        }
        
        UIView.animate(withDuration: duration) {
            view.transform = .identity
        }
    }
}


