import UIKit

class TeamTableViewCell: UITableViewCell {
    var teamNameLabel = InterfaceBuilder.createTitleLabel()
    var teamImageView = InterfaceBuilder.createImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with team: Team) {
        teamImageView.image = team.image
        teamNameLabel.text = team.teamName
    }
    
    private func setSubviews() {
        addSubviews(teamImageView, teamNameLabel)
    }
}

