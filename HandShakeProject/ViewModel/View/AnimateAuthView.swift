//
//  AnimateAuthView.swift
//  HandShakeProject
//
//  Created by Марк on 15.07.23.
//

import UIKit

extension AuthorizationViewController {
    func animateView() {
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}
    
