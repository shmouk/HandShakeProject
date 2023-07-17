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

extension UIView {
    var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
    }
    
    var radius: CGFloat {
        get {
            layer.cornerRadius
        }
        
        set {
            makeRoundCorners(with: newValue)
        }
    }
    
    var diameter: CGFloat {
        get {
            self.layer.cornerRadius * 2
        }
        
        set {
            makeRoundCorners(with: newValue / 2)
        }
    }
    
    func makeRoundCorners(with radius: CGFloat = 30) {
        layer.cornerRadius = min(radius, min(frame.width / 2 , frame.height / 2))
        layer.masksToBounds = true
    }
    
    func setShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 8
        layer.shadowOffset = .zero
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
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
}
// button  9CB9D1 tint CFDAEC view e1e6ef
