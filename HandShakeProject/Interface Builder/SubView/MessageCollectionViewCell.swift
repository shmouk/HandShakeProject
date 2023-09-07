import UIKit

class MessageCollectionViewCell: UICollectionViewCell {
    
    private let interfaceBuilder = InterfaceBuilder()
    
    lazy var messageTextView = interfaceBuilder.createTextView()
    lazy var timeTextLabel = interfaceBuilder.createDescriptionLabel()
    
    var isMessageForUser: Bool?
    var partnerUID: String?
    var cellSize = CGSize()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubviews()
        setViewAppearance()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with message: Message) {
        messageTextView.text = message.text
        timeTextLabel.text =  message.timestamp.convertTimestampToDate()
        isMessageForUser = partnerUID == message.fromId ? false : true
    }
    
    private func setViewAppearance() {
        messageTextView.backgroundColor = .colorForStroke()
        messageTextView.isEditable = false
    }
    
    private func setSubviews() {
        contentView.addSubviews(messageTextView, timeTextLabel)
    }
}

