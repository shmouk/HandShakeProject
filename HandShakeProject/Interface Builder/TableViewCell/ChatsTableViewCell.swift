import UIKit

class ChatsTableVeiwCell : UITableViewCell {
    
    lazy var nameLabel = interfaceBuilder.createTitleLabel()
    lazy var userImageView = interfaceBuilder.createImageView()
    
    let interfaceBuilder = InterfaceBuilder()
    
    var user: User? {
        didSet {
//            userImageView.image = user?.image
            nameLabel.text = user?.name
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
        contentView.addSubviews(userImageView, nameLabel)
    }
}
