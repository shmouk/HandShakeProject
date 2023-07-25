//
//  EventsModel.swift
//  HandShakeProject
//
//  Created by Марк on 19.07.23.
//

import UIKit

struct Events {
    var teamImage: UIImage
    var titleLabel: String
    var descriptionLabel: String
    var dateLabel: String?
}

struct Event {
    var team: String
    var nameEvent: String
    var descriptionName: String
    var deadlineState: Int
    var date: String?
    var executor: String
    var reader: String
}
