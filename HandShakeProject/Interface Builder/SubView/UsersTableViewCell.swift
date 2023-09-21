import UIKit

class UsersTableViewCell : UITableViewCell {
    
    var nameLabel = InterfaceBuilder.createTitleLabel()
    var userImageView = InterfaceBuilder.createImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with user: User) {
        userImageView.image = user.image
        nameLabel.text = user.name
    }
    
    private func setSubviews() {
        addSubviews(userImageView, nameLabel)
    }
    
}
