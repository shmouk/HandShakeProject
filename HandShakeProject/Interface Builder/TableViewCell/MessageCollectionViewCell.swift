//
//  MessageCollectionViewCell.swift
//  HandShakeProject
//
//  Created by Марк on 7.08.23.
//

import UIKit

class MessageCollectionViewCell: UICollectionViewCell {
    
    lazy var messageTextView = interfaceBuilder.createTextView()
    lazy var timeTextLabel = interfaceBuilder.createDescriptionLabel()

    let interfaceBuilder = InterfaceBuilder()
    
    var message: Message? {
        didSet {
            messageTextView.text = message?.text
            timeTextLabel.text = convertTimestampToDate(message?.timeStamp ?? 0)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubviews()
        setupConstraints()
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func convertTimestampToDate(_ timestamp: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return dateFormatter.string(from: date)
    }

    private func setSubviews() {
        addSubviews(messageTextView, timeTextLabel)

    }
}
