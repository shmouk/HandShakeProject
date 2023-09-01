//
//  EventsModel.swift
//  HandShakeProject
//
//  Created by Марк on 19.07.23.
//

import UIKit


class Event {
    @objc dynamic var creatorInfo: User
    @objc dynamic var nameEvent: String
    @objc dynamic var descriptionText: String
    @objc dynamic var deadlineState: Int
    @objc dynamic var date: Int
    @objc dynamic var executorInfo: User
    @objc dynamic var readerList: [String]
    
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
