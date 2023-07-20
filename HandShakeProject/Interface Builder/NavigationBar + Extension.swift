//
//  NavigationBar + Extension.swift
//  HandShakeProject
//
//  Created by Марк on 20.07.23.
//

import UIKit

extension UINavigationController {
    
    func setupNavBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.compactAppearance = appearance
        self.navigationBar.standardAppearance = appearance
        
        self.navigationBar.tintColor = .colorForTitleText()
        UIBarButtonItem.appearance().tintColor = .black
    }
}
