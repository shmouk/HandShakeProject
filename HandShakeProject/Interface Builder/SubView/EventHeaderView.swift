import UIKit

class EventHeaderView: UITableViewHeaderFooterView {
   var teamName = InterfaceBuilder.createTitleLabel()
   var teamImage = InterfaceBuilder.createImageView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setSubviews()
        setViewAppearance()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) hasnot been implemented")
    }
    
    func configure(with data: (UIImage, String)?) {
        teamImage.image = data?.0
        teamName.text = data?.1
    }
    
    private func setSubviews() {
       contentView.addSubviews(teamImage, teamName)
    }
    
    private func setViewAppearance() {
        contentView.layer.masksToBounds = false
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .colorForStroke()
        teamName.font = UIFont.boldSystemFont(ofSize: 24)
    }
}

