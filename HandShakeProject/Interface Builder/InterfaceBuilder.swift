//
//  InterfaceBuilder.swift
//  HandShakeProject
//
//  Created by Марк on 14.07.23.
//

import UIKit

class InterfaceBuilder {
    
    func createView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
       return view
    }
    
    func createSegmentControl(items: [Any]?) -> UISegmentedControl {
        let viewSC = UISegmentedControl(items: items)
        viewSC.translatesAutoresizingMaskIntoConstraints = false
        return viewSC
    }
    
    func createTextField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        textField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textField.borderStyle = .line
        textField.layer.borderWidth = 1.0
        return textField
    }
    
    func createLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }
    
    func createButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        button.layer.borderWidth = 1.0
        button.backgroundColor = .clear
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        return button
    }
}
