import UIKit

class MessageTextTableViewCell: UITableViewCell {
    
    private let interfaceBuilder = InterfaceBuilder()
    
    lazy var messageLabel = interfaceBuilder.createTitleLabel()
    lazy var timeTextLabel = interfaceBuilder.createDescriptionLabel()
    lazy var customBackgroundView = interfaceBuilder.createView()

    var isMessageForUser: Bool?
    var partnerUID: String?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setSubviews()
        setViewAppearance()
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
        backgroundColor = .clear
        messageLabel.backgroundColor = .colorForSubview()
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
    }
    
    private func setSubviews() {
        addSubviews(customBackgroundView, messageLabel, timeTextLabel)
    }
}

