import UIKit

class MessageTableViewCell: UITableViewCell {
    
    lazy var nameLabel = interfaceBuilder.createTitleLabel()
    lazy var uidLabel = interfaceBuilder.createTitleLabel()
    lazy var messageTextLabel = interfaceBuilder.createDescriptionLabel()

//    lazy var userImageView = interfaceBuilder.createImageView()
    
    let interfaceBuilder = InterfaceBuilder()
    
    var message: Message? {
        didSet {
            uidLabel.text = message?.uid
            messageTextLabel.text = message?.text
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
        contentView.addSubviews(uidLabel, messageTextLabel)
    }
}
