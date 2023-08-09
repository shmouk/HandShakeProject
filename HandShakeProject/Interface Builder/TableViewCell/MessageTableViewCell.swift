import UIKit

class MessageTableViewCell: UITableViewCell {
    
    lazy var nameLabel = interfaceBuilder.createTitleLabel()
    lazy var messageTextLabel = interfaceBuilder.createDescriptionLabel()
    lazy var userImageView = interfaceBuilder.createImageView()
    lazy var timeTextLabel = interfaceBuilder.createDescriptionLabel()

    let interfaceBuilder = InterfaceBuilder()
    
    var message: Message? {
        didSet {
            userImageView.image = message?.image
            nameLabel.text = message?.name
            messageTextLabel.text = message?.text
            timeTextLabel.text = convertTimestampToDate(message?.timeStamp ?? 0)
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
    
    private func convertTimestampToDate(_ timestamp: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return dateFormatter.string(from: date)
    }

    private func setSubviews() {
        contentView.addSubviews(userImageView, nameLabel, messageTextLabel, timeTextLabel)
    }
}
