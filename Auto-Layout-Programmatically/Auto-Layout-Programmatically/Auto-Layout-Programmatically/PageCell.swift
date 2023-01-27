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
    
    let foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let imageContainerView: UIView = {
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
    
    func imageViewContraints() {
        foodImageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor).isActive = true
        foodImageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor).isActive = true
        foodImageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        foodImageView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 0.5).isActive = true
    }
    
    private func descriptionViewContraints() {
        descriptionTextView.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 20).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
    }
    
    private func imageContainerViewContraints() {
        imageContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        imageContainerView.addSubview(foodImageView)
        imageViewContraints()
    }
}
