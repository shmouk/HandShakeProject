import UIKit

class EventTableViewCell : UITableViewCell {
    
    lazy var titleLabel = interfaceBuilder.createTitleLabel()
    lazy var descriptionLabel = interfaceBuilder.createDescriptionLabel()
    lazy var dateLabel = interfaceBuilder.createTitleLabel()
    lazy var teamImageView = interfaceBuilder.createImageView()
    
    let interfaceBuilder = InterfaceBuilder()
    
    var event: Events? {
        didSet {
            teamImageView.image = event?.teamImage
            titleLabel.text = event?.titleLabel
            descriptionLabel.text = event?.descriptionLabel
            dateLabel.text = event?.dateLabel
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setSubviews() {
        addSubviews(teamImageView, titleLabel, descriptionLabel, dateLabel)
    }
}
