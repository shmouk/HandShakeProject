import UIKit

class MessageTextTableViewCell: UITableViewCell {
    var messageLabel = InterfaceBuilder.createTitleLabel()
    var timeTextLabel = InterfaceBuilder.createDescriptionLabel()
    var customBackgroundView = InterfaceBuilder.createView()
    
    var isMessageForUser: Bool?
    var partnerUID: String?
    var backgroundLeadingConstraint: NSLayoutConstraint?
    var backgroundTrailingConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViewAppearance()
        setSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with message: Message) {
        messageLabel.text = message.text
        timeTextLabel.text =  message.timestamp.convertTimestampToDate()
        isMessageForUser = partnerUID == message.fromId ? false : true
        setupConstraints()
    }
    
    private func setViewAppearance() {
        backgroundColor = .colorForView()
        customBackgroundView.backgroundColor = .colorForSubview()
        messageLabel.layer.cornerRadius = 0
        messageLabel.backgroundColor = .colorForSubview()
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
    }
    
    private func setSubviews() {
        addSubviews(customBackgroundView)
        customBackgroundView.addSubviews(messageLabel, timeTextLabel)
    }
}

