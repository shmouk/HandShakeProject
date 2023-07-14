//
//  UIView + Extension.swift
//  HandShakeProject
//
//  Created by Марк on 14.07.23.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
