//
//  TaskCell.swift
//  Calendar
//
//  Created by Admin on 24.01.2021.
//

import Foundation
import UIKit



class TaskCell: UITableViewCell {
    let constantForLeftAndRightAnchor: CGFloat = 20
    let constantForTopAndbottomAnchor: CGFloat = 10
    var titleLabel = UILabel()
    let timeLable = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addAllSubViewOnTheCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addAllSubViewOnTheCell() {
        timeLable.textAlignment = .left
        timeLable.sizeToFit()
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        
        self.timeLable.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(timeLable)
        self.addSubview(titleLabel)
        
        self.timeLable.leftAnchor.constraint(
            equalTo: self.contentView.leftAnchor, constant: constantForLeftAndRightAnchor
        ).isActive = true
        self.timeLable.topAnchor.constraint(
            equalTo: self.contentView.topAnchor, constant: 2
        ).isActive = true
        self.timeLable.rightAnchor.constraint(
            equalTo: self.contentView.rightAnchor, constant: -constantForLeftAndRightAnchor
        ).isActive = true
        self.timeLable.bottomAnchor.constraint(
            equalTo: self.contentView.bottomAnchor, constant: -self.contentView.frame.height / 3
        ).isActive = true
        
        
        self.titleLabel.leftAnchor.constraint(
            equalTo: self.contentView.leftAnchor, constant: constantForLeftAndRightAnchor
        ).isActive = true
        
        self.titleLabel.topAnchor.constraint(
            equalTo: self.timeLable.bottomAnchor, constant: 5
        ).isActive = true
        
        self.titleLabel.rightAnchor.constraint(
            equalTo: self.contentView.rightAnchor, constant: -constantForLeftAndRightAnchor
        ).isActive = true
        
        self.titleLabel.bottomAnchor.constraint(
            equalTo: self.contentView.bottomAnchor, constant: 10
        ).isActive = true
    }
    
    
}
