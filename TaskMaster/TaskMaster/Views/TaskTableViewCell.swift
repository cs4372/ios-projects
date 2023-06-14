//
//  TaskTableViewCell.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/14/23.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
     
    }
    
    func setup(with task: Task) {
        taskLabel.text = task.title
    }
    
}
