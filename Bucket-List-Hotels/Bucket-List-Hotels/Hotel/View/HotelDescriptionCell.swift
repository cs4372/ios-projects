//
//  HotelDescriptionCell.swift
//  Bucket-List-Hotels
//
//  Created by Catherine Shing on 1/4/23.
//

import UIKit

class HotelDescriptionCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = .systemYellow
    }
    
    @IBOutlet var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 0
        }
    }
}

