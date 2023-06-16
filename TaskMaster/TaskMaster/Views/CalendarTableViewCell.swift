//
//  CalendarTableViewCell.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/14/23.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    @IBOutlet weak var taskLabel: UILabel!
    
    func setup(with task: Task) {
        taskLabel.text = task.title
    }
}
