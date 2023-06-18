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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!
    
    override func awakeFromNib() {
         super.awakeFromNib()
         
         layer.cornerRadius = 10
     }
    
    func setup(with task: Task) {
        taskLabel?.text = task.title ?? "No Tasks Added Yet"
        dateLabel?.text = DateHelper.formattedDate(from: task.dueDate!)
        
        guard let color = UIColor(hexString: task.taskColor) else {
            return
        }
        
        taskLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        dateLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        backgroundColor = color
        
        let checkboxImageName = task.isCompleted ? "checkmark.circle" : "circle"
        
        if let checkboxImage = UIImage(systemName: checkboxImageName)?.withTintColor(ContrastColorOf(color, returnFlat: true)) {
            let imageSize = CGSize(width: 40, height: 40)
            
            let renderer = UIGraphicsImageRenderer(size: imageSize)
            let resizedCheckboxImage = renderer.image { _ in
                checkboxImage.draw(in: CGRect(origin: .zero, size: imageSize))
            }
            
            checkboxButton?.setImage(resizedCheckboxImage, for: .normal)
        }
    }
}
