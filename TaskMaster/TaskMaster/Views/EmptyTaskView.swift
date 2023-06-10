//
//  EmptyTaskView.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/9/23.
//

import UIKit
import CLTypingLabel
import ChameleonFramework

extension UICollectionView {
    
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: bounds)
        
        let titleLabel = createTitleLabel()
        let messageLabel = createMessageLabel()
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)

        setupConstraints(for: titleLabel, messageLabel, in: emptyView)
        
        titleLabel.text = title
        messageLabel.text = message
        
        self.backgroundView = emptyView
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
    private func createTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.flatWatermelon()
        titleLabel.font = UIFont(name: "Futura", size: 18)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        return titleLabel
    }
    
    private func createMessageLabel() -> UILabel {
        let messageLabel = CLTypingLabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .lightGray
        messageLabel.font = UIFont(name: "Futura", size: 17)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        return messageLabel
    }
    
    private func setupConstraints(for titleLabel: UILabel, _ messageLabel: UILabel, in emptyView: UIView) {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -80),
            titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -20)
        ])
    }
}
