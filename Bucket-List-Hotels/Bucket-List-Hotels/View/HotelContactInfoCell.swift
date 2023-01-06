//
//  HotelContactInfoCell.swift
//  Bucket-List-Hotels
//
//  Created by Catherine Shing on 1/4/23.
//

import UIKit

class HotelContactInfoCell: UITableViewCell {
    
    @IBOutlet var addressTextLabel: UILabel! {
        didSet {
            addressTextLabel.numberOfLines = 0
        }
    }
    @IBOutlet var phoneNumberTextLabel: UILabel! {
        didSet {
            phoneNumberTextLabel.numberOfLines = 0
        }
    }
}

