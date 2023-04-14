//
//  SectionHeaderView.swift
//  Todo-List
//
//  Created by Catherine Shing on 4/13/23.
//

import UIKit

class SectionHeaderView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
         NSLayoutConstraint.activate([
             titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
             titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
             titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
             titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
         ])
     }
}
