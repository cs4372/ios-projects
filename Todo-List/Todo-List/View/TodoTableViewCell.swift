//
//  TodoTableViewCell.swift
//  Todo-List
//
//  Created by Catherine Shing on 2/16/23.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    
    let todoTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(todoTextLabel)
        
        NSLayoutConstraint.activate([
            todoTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            todoTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            todoTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            todoTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5),
            todoTextLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
