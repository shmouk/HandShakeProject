import UIKit

class EventHeaderView: UITableViewHeaderFooterView {
    private let interfaceBuilder = InterfaceBuilder()

    lazy var teamName = interfaceBuilder.createTitleLabel()
    lazy var teamImage = interfaceBuilder.createImageView()
    
    var teamInfo: (UIImage, String)? {
        didSet {
            teamImage.image = teamInfo?.0
            teamName.text = teamInfo?.1
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setSubviews()
        setViewAppearance()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) hasnot been implemented")
    }
    
    private func setSubviews() {
        contentView.backgroundColor = .colorForStroke()
        addSubviews(teamImage, teamName)
    }
    private func setViewAppearance() {
        teamName.font = UIFont.boldSystemFont(ofSize: 24)
    }
}

