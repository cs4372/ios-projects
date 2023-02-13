//
//  RecipeTableViewCell.swift
//  MealFinder
//
//  Created by Catherine Shing on 2/12/23.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mealName: UILabel! {
        didSet {
            mealName.numberOfLines = 0
        }
    }
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var mealCategory: UILabel! {
        didSet {
            mealCategory.numberOfLines = 0
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

