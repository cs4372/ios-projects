//
//  AddTaskController.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/7/23.
//

import UIKit
import PanModal
import ChameleonFramework

protocol AddTaskViewControllerDelegate: AnyObject {
    func didAddTask(_ task: Task)
}

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    
    weak var delegate: AddTaskViewControllerDelegate?
        
    override func viewDidLoad() {
        saveButton.layer.cornerRadius = 5
        saveButton.backgroundColor = FlatWatermelon()
    }
    
    @IBAction func saveTask(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newTask = Task(context: context)
        newTask.title = titleText.text
        newTask.dueDate = dueDate.date
        newTask.taskColor = RandomFlatColorWithShade(.light).hexValue()
        newTask.isCompleted = false
          
        delegate?.didAddTask(newTask)
          
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddTaskViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(300)
    }
}
