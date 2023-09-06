import UIKit

class MessageTableViewCell: UITableViewCell {
    private let interfaceBuilder = InterfaceBuilder()

    lazy var nameLabel = interfaceBuilder.createTitleLabel()
    lazy var messageTextLabel = interfaceBuilder.createDescriptionLabel()
    lazy var userImageView = interfaceBuilder.createImageView()
    lazy var timeTextLabel = interfaceBuilder.createDescriptionLabel()
    
    var message: Message? {
        didSet {
            userImageView.image = message?.image
            nameLabel.text = message?.name
            messageTextLabel.text = message?.text
            timeTextLabel.text = message?.timestamp.convertTimestampToDate()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setSubviews() {
        contentView.addSubviews(userImageView, nameLabel, messageTextLabel, timeTextLabel)
    }
}
