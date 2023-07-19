import UIKit

class ChatsTableVeiwCell : UITableViewCell {
    
    lazy var nameLabel = interfaceBuilder.createTitleLabel()
    lazy var friendImageView = interfaceBuilder.createImageView()
    
    let interfaceBuilder = InterfaceBuilder()
    
    var friend: Template? {
        didSet {
            friendImageView.image = friend?.image
            nameLabel.text = friend?.nameLabel
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
        contentView.addSubviews(friendImageView, nameLabel)
    }
}
