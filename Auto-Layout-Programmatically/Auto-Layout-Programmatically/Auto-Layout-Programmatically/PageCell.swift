//
//  PageCell.swift
//  Auto-Layout-Programmatically
//
//  Created by Catherine Shing on 1/22/23.
//

import UIKit

class PageCell: UICollectionViewCell {
    // everytime you swap through the page, it will set the below page props
    var page: Page? {
        didSet {
            guard let unwrappedPage = page else { return }
            foodImageView.image = UIImage(named: unwrappedPage.imageName)
            let firstAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 20),
                .foregroundColor: UIColor.cyan
            ]
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.paragraphSpacingBefore = 10
            let secondAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 15),
                .foregroundColor: UIColor.gray,
                .paragraphStyle: paragraphStyle
            ]
            let firstString = NSMutableAttributedString(string: "\(unwrappedPage.headerText)\n", attributes: firstAttributes)
            let secondString = NSAttributedString(string: unwrappedPage.descriptionText, attributes: secondAttributes)
            
            firstString.append(secondString)
            descriptionTextView.attributedText = firstString
            descriptionTextView.textAlignment = .center
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageContainerView)
        imageContainerViewContraints()
        addSubview(descriptionTextView)
        descriptionViewContraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init has not been implemented")
    }
    
    private let foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let imageContainerView: UIView = {
        let imageContainer = UIView()
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        return imageContainer
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    private func descriptionViewContraints() {
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        ])
    }
    
    private func imageContainerViewContraints() {
        NSLayoutConstraint.activate([
            imageContainerView.topAnchor.constraint(equalTo: self.topAnchor),
            imageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        ])
        imageContainerView.addSubview(foodImageView)
        imageViewContraints()
    }
    
    private func imageViewContraints() {
        NSLayoutConstraint.activate([
            foodImageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            foodImageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            foodImageView.widthAnchor.constraint(equalToConstant: 250),
            foodImageView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 0.5)
        ])
    }
}
