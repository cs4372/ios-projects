//
//  ChatCell.swift
//  ChatApp
//
//  Created by Catherine Shing on 5/9/23.
//

import UIKit

class ChatCell: UITableViewCell {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.rectangle")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
    }
    
    let messageBubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        return view
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: Constants.BrandColors.backgroundColor)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var messageBubbleViewLeftConstraint: NSLayoutConstraint!
    var messageBubbleViewRightConstraint: NSLayoutConstraint!
    var profileImageViewLeftConstraint: NSLayoutConstraint!
    var profileImageViewRightConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "chatCell")
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(messageBubbleView)
        messageBubbleView.addSubview(messageLabel)
                        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            messageBubbleView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            messageBubbleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            messageBubbleView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),

            
            messageLabel.topAnchor.constraint(equalTo: messageBubbleView.topAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: messageBubbleView.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: messageBubbleView.trailingAnchor, constant: -8),
            messageLabel.centerXAnchor.constraint(equalTo: messageBubbleView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: messageBubbleView.centerYAnchor),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
        ])
        
        profileImageViewLeftConstraint = profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        profileImageViewRightConstraint = profileImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        messageBubbleViewLeftConstraint = messageBubbleView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20)
        messageBubbleViewRightConstraint = messageBubbleView.trailingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: -20)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
