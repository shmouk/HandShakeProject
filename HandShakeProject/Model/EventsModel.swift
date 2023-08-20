//
//  EventsModel.swift
//  HandShakeProject
//
//  Created by Марк on 19.07.23.
//

import UIKit

class Events {
    var teamImage: UIImage?
    var titleLabel: String
    var descriptionLabel: String
    var dateLabel: String?
    
    init(teamImage: UIImage? = nil, titleLabel: String = "", descriptionLabel: String = "", dateLabel: String? = nil) {
        self.teamImage = teamImage
        self.titleLabel = titleLabel
        self.descriptionLabel = descriptionLabel
        self.dateLabel = dateLabel
    }
}

class Event {
    var teamId: String
    var nameEvent: String
    var descriptionName: String
    var deadlineState: Int
    var date: String?
    var executor: String?
    var reader: String
    
    init(teamId: String = "", nameEvent: String = "", descriptionName: String = "", deadlineState: Int = 0, date: String? = nil, executor: String? = nil, reader: String = "") {
        self.teamId = teamId
        self.nameEvent = nameEvent
        self.descriptionName = descriptionName
        self.deadlineState = deadlineState
        self.date = date
        self.executor = executor
        self.reader = reader
    }
}
