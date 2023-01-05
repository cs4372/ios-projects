//
//  HotelTableViewCell.swift
//  Bucket-List-Hotels
//
//  Created by Catherine Shing on 1/4/23.
//

import UIKit

class HotelTableViewCell: UITableViewCell {
    
    @IBOutlet var imageCellView: UIImageView!
    @IBOutlet var nameLabel: UILabel! {
        didSet {
            nameLabel.numberOfLines = 0
        }
    }
    
    
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var starsLabel: UILabel!
    
}
