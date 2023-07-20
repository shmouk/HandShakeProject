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

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}

extension UIColor {
    static func colorForStroke() -> UIColor {
        return #colorLiteral(red: 0.8117647059, green: 0.8549019608, blue: 0.9254901961, alpha: 1)
    }
    static func colorForButton() -> UIColor {
        return #colorLiteral(red: 0.6117647059, green: 0.7254901961, blue: 0.8196078431, alpha: 1)
    }
    static func colorForView() -> UIColor {
        return #colorLiteral(red: 0.8823529412, green: 0.9019607843, blue: 0.937254902, alpha: 1)
    }
    static func colorForTitleText() -> UIColor {
        return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    static func colorForDescriptionText() -> UIColor {
        return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
}
// button  9CB9D1 tint CFDAEC view e1e6ef
