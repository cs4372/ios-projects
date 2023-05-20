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
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
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
        
        messageLabel.numberOfLines = 0
         messageLabel.lineBreakMode = .byWordWrapping
         
         messageBubbleView.layer.cornerRadius = 10
         messageBubbleView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            messageBubbleView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            messageBubbleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            messageLabel.topAnchor.constraint(equalTo: messageBubbleView.topAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: messageBubbleView.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: messageBubbleView.trailingAnchor, constant: -8),
            messageLabel.centerXAnchor.constraint(equalTo: messageBubbleView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: messageBubbleView.centerYAnchor),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            messageBubbleView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
