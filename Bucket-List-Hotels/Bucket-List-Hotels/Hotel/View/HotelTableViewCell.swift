//
//  HotelTableViewCell.swift
//  Bucket-List-Hotels
//
//  Created by Catherine Shing on 1/4/23.
//

import UIKit

class HotelTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = .systemYellow
    }
    
    @IBOutlet var imageCellView: UIImageView!
    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet weak var starsStackView: UIStackView!
    
    func setStars(_ stars: Int) {
        let fullStarImage = UIImage(systemName: "star.fill")
        let emptyStarImage = UIImage(systemName: "star")
        let starSize: CGFloat = 10.0
        
        for i in 0..<5 {
            let imageView = UIImageView(image: i < stars ? fullStarImage : emptyStarImage)
            imageView.frame = CGRect(x: i * Int(starSize), y: 0, width: Int(starSize), height: Int(starSize))
            starsStackView.addArrangedSubview(imageView)
        }
    }
}
