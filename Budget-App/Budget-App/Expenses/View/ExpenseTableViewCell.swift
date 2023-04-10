//
//  ExpenseTableViewCell.swift
//  Budget-App
//
//  Created by Catherine Shing on 2/26/23.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var expenseLabel: UILabel! {
        didSet {
            expenseLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
}
