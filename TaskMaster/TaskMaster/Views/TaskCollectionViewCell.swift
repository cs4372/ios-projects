//
//  TaskCollectionViewCell.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/6/23.
//

import UIKit
import ChameleonFramework

class TaskCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!
    
    override func awakeFromNib() {
         super.awakeFromNib()
         
         layer.cornerRadius = 10
     }
    
    func setup(with task: Task) {
        taskLabel.text = task.title ?? "No Tasks Added Yet"
        DateLabel.text = DateHelper.formattedDate(from: task.dueDate!)
        
        guard let color = UIColor(hexString: task.taskColor) else {
            return
        }
        
        taskLabel.textColor = ContrastColorOf(color, returnFlat: true)
        DateLabel.textColor = ContrastColorOf(color, returnFlat: true)
        backgroundColor = color
        
        let checkboxImageName = task.isCompleted ? "checkmark.circle" : "circle"
        
        if let checkboxImage = UIImage(systemName: checkboxImageName)?.withTintColor(ContrastColorOf(color, returnFlat: true)) {
            let imageSize = CGSize(width: 40, height: 40)
            
            let renderer = UIGraphicsImageRenderer(size: imageSize)
            let resizedCheckboxImage = renderer.image { context in
                checkboxImage.draw(in: CGRect(origin: .zero, size: imageSize))
            }
            
            checkboxButton.setImage(resizedCheckboxImage, for: .normal)
        }
    }
}
