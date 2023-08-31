//
//  EventsModel.swift
//  HandShakeProject
//
//  Created by Марк on 19.07.23.
//

import UIKit


class Event {
    var creatorInfo: User
    var nameEvent: String
    var descriptionText: String
    var deadlineState: Int
    var date: Int
    var executorInfo: User
    var readerList: [String]
    
    init(creatorInfo: User = User(), nameEvent: String = "", descriptionText: String = "", deadlineState: Int = 0, date: Int = 0, executorInfo: User = User(), readerList: [String] = []) {
        self.creatorInfo = creatorInfo
        self.nameEvent = nameEvent
        self.descriptionText = descriptionText
        self.deadlineState = deadlineState
        self.date = date
        self.executorInfo = executorInfo
        self.readerList = readerList
    }
}
