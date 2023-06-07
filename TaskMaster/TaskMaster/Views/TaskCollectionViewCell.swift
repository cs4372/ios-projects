//
//  TaskCollectionViewCell.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/6/23.
//

import UIKit

class TaskCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!
    
    override func awakeFromNib() {
         super.awakeFromNib()
         
         layer.cornerRadius = 10
     }
}
