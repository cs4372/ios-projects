//
//  ChatCell.swift
//  ChatApp
//
//  Created by Catherine Shing on 5/9/23.
//

import UIKit

class ChatCell: UITableViewCell {
    let messageBubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = .blue
        return view
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var messageBubbleViewLeftConstraint: NSLayoutConstraint!
    var messageBubbleViewRightConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "chatCell")
        
        contentView.addSubview(messageBubbleView)
        messageBubbleView.addSubview(messageLabel)
        
         messageBubbleViewLeftConstraint = messageBubbleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
         messageBubbleViewRightConstraint = messageBubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        
        NSLayoutConstraint.activate([
            messageBubbleView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            messageBubbleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            messageLabel.topAnchor.constraint(equalTo: messageBubbleView.topAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: messageBubbleView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: messageBubbleView.trailingAnchor, constant: -16),
            messageLabel.centerXAnchor.constraint(equalTo: messageBubbleView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: messageBubbleView.centerYAnchor),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200), // Maximum width of the label
             messageBubbleView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50), // Minimum width of the bubble view
        ])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
