import UIKit

class EventTableViewCell: UITableViewCell {
    private let interfaceBuilder = InterfaceBuilder()

    lazy var titleLabel = interfaceBuilder.createTitleLabel()
    lazy var descriptionLabel = interfaceBuilder.createDescriptionLabel()
    lazy var dateLabel = interfaceBuilder.createTitleLabel()
    lazy var executorImageView = interfaceBuilder.createImageView()
    
    var event: Event? {
        didSet {
            executorImageView.image = event?.executorInfo.image
            titleLabel.text = event?.nameEvent
            descriptionLabel.text = event?.descriptionText
            dateLabel.text = event?.date.convertTimestampToDate(timeStyle: .medium)
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
        addSubviews(executorImageView, titleLabel, descriptionLabel, dateLabel)
    }
}
