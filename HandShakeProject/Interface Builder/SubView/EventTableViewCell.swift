import UIKit

class EventTableViewCell: UITableViewCell {
    var titleLabel = InterfaceBuilder.createTitleLabel()
    var descriptionLabel = InterfaceBuilder.createDescriptionLabel()
    var dateLabel = InterfaceBuilder.createTitleLabel()
    var executorImageView = InterfaceBuilder.createImageView()
    var stateView = InterfaceBuilder.createView()
    
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
