//
//  AnimateAuthView.swift
//  HandShakeProject
//
//  Created by Марк on 15.07.23.
//

import UIKit

extension AuthorizationViewController {
    func animateView() {
        let newLeadingConstant = leadingConstraint?.constant == 30 ? view.frame.width / 2 : 30
        let newTrailingConstant = trailingConstraint?.constant == -view.frame.width / 2 ? -30 : -view.frame.width / 2
        
        leadingConstraint?.constant = CGFloat(newLeadingConstant)
        trailingConstraint?.constant = CGFloat(newTrailingConstant)
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}
    
