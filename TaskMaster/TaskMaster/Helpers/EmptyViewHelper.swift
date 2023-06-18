//
//  EmptyViewHelper.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/12/23.
//

import UIKit
import CLTypingLabel
import ChameleonFramework

protocol EmptyView: AnyObject {
    var backgroundView: UIView? { get set }
    var bounds: CGRect { get }
}

extension UITableView: EmptyView {}
extension UICollectionView: EmptyView {}

class EmptyViewHelper {
    static func setEmptyView(for view: EmptyView, frame: CGRect, title: String, message: String) {
        let emptyView = UIView(frame: frame)
        let titleLabel = createTitleLabel()
        let messageLabel = createMessageLabel()
        
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        
        setupConstraints(for: titleLabel, messageLabel, in: emptyView)
        
        titleLabel.text = title
        messageLabel.text = message
        
        view.backgroundView = emptyView
    }
    
    static func restore(for view: EmptyView) {
        view.backgroundView = nil
    }
    
    private static func createTitleLabel() -> UILabel {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.flatWatermelon()
        titleLabel.font = UIFont(name: "Futura", size: 18)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        return titleLabel
    }
    
    private static func createMessageLabel() -> UILabel {
        let messageLabel = CLTypingLabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .lightGray
        messageLabel.font = UIFont(name: "Futura", size: 17)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        return messageLabel
    }
    
    private static func setupConstraints(for titleLabel: UILabel, _ messageLabel: UILabel, in emptyView: UIView) {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -80),
            titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -20)
        ])
    }
}
