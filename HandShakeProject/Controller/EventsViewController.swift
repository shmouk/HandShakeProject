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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image:  UIImage(systemName: "bell.badge"), style: .plain, target: self, action: #selector(addEventsAction))

    }
    @objc
    private func addEventsAction(_ sender: Any) {
        print(1)
    }
}
