//
//  TeamTableViewCell.swift
//  HandShakeProject
//
//  Created by Марк on 11.08.23.
//

import UIKit

class TeamTableViewCell: UITableViewCell {
    private let interfaceBuilder = InterfaceBuilder()

    lazy var teamNameLabel = interfaceBuilder.createTitleLabel()
    lazy var teamImageView = interfaceBuilder.createImageView()
    
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

