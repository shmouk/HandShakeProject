import UIKit

class MessageCollectionViewCell: UICollectionViewCell {
    
    lazy var messageTextView = interfaceBuilder.createTextView()
    lazy var timeTextLabel = interfaceBuilder.createDescriptionLabel()
    let interfaceBuilder = InterfaceBuilder()
    
    var isMessegeForUser: Bool? {
        didSet {
            setupConstraints() // Добавляем вызов метода setupConstraints()
        }
    }

    var partnerUID: String?
    var currentUID = UserChatViewModel.currentUID
    
    var message: Message? {
        didSet {
            isMessegeForUser = currentUID == message?.fromId ? true : false
            print(1, isMessegeForUser)
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
        dateFormatter.dateFormat = "hh:mm"
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return dateFormatter.string(from: date)
    }

    private func setSubviews() {
        addSubviews(messageTextView, timeTextLabel)
    }
}
