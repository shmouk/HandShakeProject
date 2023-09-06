import UIKit

class MessageCollectionViewCell: UICollectionViewCell {
    
    private let interfaceBuilder = InterfaceBuilder()
    
    lazy var messageTextView = interfaceBuilder.createTextView()
    lazy var timeTextLabel = interfaceBuilder.createDescriptionLabel()
    
    var isMessageForUser: Bool? {
        didSet {
            setupConstraints()
        }
    }
    var width = CGFloat()
    var partnerUID: String?
    
    var message: Message? {
        didSet {
            setupText()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubviews()
        setViewAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setSubviews()
        setViewAppearance()
    }
    
    private func setupText() {
        messageTextView.text = message?.text
        timeTextLabel.text =  message?.timestamp.convertTimestampToDate()
        isMessageForUser = partnerUID == message?.fromId ? false : true
    }
    
    private func setViewAppearance() {
        messageTextView.backgroundColor = .colorForStroke()
        messageTextView.isEditable = false
    }
    
    private func setSubviews() {
        contentView.addSubview(messageTextView)
        contentView.addSubview(timeTextLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        setupConstraints()
    }
}

