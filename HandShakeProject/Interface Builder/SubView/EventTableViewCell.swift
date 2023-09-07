import UIKit

class EventTableViewCell: UITableViewCell {
    private let interfaceBuilder = InterfaceBuilder()

    lazy var titleLabel = interfaceBuilder.createTitleLabel()
    lazy var descriptionLabel = interfaceBuilder.createDescriptionLabel()
    lazy var dateLabel = interfaceBuilder.createTitleLabel()
    lazy var executorImageView = interfaceBuilder.createImageView()
    lazy var stateView = interfaceBuilder.createView()
    
    var sizeForView = CGSize()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViewAppearance()
        setSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setSubviews() {
        addSubviews(stateView, titleLabel, executorImageView, descriptionLabel, dateLabel)
    }
    
    func configure(with event: Event) {
        executorImageView.image = event.executorInfo.image
        titleLabel.text = event.nameEvent
        sizeForView = calculateSizeForView()
        descriptionLabel.text = event.descriptionText
        stateView.backgroundColor = .getColorFromDeadlineState(event.deadlineState)
        dateLabel.text = event.date.convertTimestampToDate(timeStyle: .medium)
        setupConstraints()
    }
    
    func setViewAppearance() {
        descriptionLabel.lineBreakMode = .byTruncatingMiddle
        descriptionLabel.textAlignment = .left
        descriptionLabel.contentMode = .topLeft
    }
    
    private func calculateSizeForView() -> CGSize {
        return titleLabel.calculateSize()
    }
}
