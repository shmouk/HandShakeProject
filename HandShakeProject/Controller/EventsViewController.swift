//
//  EventsViewController.swift
//  HandShakeProject
//
//  Created by Марк on 15.07.23.
//

import UIKit

class EventsViewController: UIViewController {
    override func viewDidLoad() {

        view.backgroundColor = .green
        super.viewDidLoad()
    }
    
    deinit {
        print("1")
    }
    
    @objc
    private func addEventsAction(_ sender: Any) {
        print(1)
    }
}
