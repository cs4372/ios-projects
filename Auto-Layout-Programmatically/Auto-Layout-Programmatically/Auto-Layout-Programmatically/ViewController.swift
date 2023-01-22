//
//  ViewController.swift
//  Auto-Layout-Programmatically
//
//  Created by Catherine Shing on 1/22/23.
//

import UIKit

class ViewController: UIViewController {
    
    let teaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "candle-tea.jpg")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let imageContainerView: UIView = {
        let imageContainer = UIView()
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        return imageContainer
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
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
        let firstString = NSMutableAttributedString(string: "Welcome to Floofy cafe \n", attributes: firstAttributes)
        let secondString = NSAttributedString(string: "Eat. Drink. Love. We believe everyone deserves love and coffee! ", attributes: secondAttributes)
        
        firstString.append(secondString)

        textView.attributedText = firstString
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(imageContainerView)
        imageContainerViewContraints()
        view.addSubview(descriptionTextView)
        descriptionViewContraints()
    }
    
    private func imageViewContraints() {
        teaImageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor).isActive = true
        teaImageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor).isActive = true
//        teaImageView.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 150).isActive = true
        teaImageView.widthAnchor.constraint(equalToConstant: 145).isActive = true
        teaImageView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 0.5).isActive = true
    }
    
    private func descriptionViewContraints() {
        descriptionTextView.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    private func imageContainerViewContraints() {
        imageContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        imageContainerView.addSubview(teaImageView)
        imageViewContraints()
    }
}

