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
    func didEditTask(_ task: Task)
}

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    
    var taskToEdit: Task?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    weak var delegate: AddTaskViewControllerDelegate?
        
    override func viewDidLoad() {
        titleText.delegate = self
        
        saveButton.layer.cornerRadius = 5
        saveButton.backgroundColor = FlatWatermelon()
        
        if let editTask = taskToEdit {
            dueDate.date = editTask.dueDate!
            titleText.text = editTask.title!
        }
    }
    
    @IBAction func saveTask(_ sender: UIButton) {
        guard let text = titleText.text, !text.isEmpty else {
            return
        }
        
        if let taskToEdit = taskToEdit {
             taskToEdit.title = titleText.text
             taskToEdit.dueDate = dueDate.date
             delegate?.didEditTask(taskToEdit)
         } else {
             let newTask = Task(context: context)
             newTask.title = titleText.text
             newTask.dueDate = dueDate.date
             newTask.taskColor = RandomFlatColorWithShade(.light).hexValue()
             newTask.isCompleted = false
             
             delegate?.didAddTask(newTask)
         }
                    
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: UITextFieldDelegate

extension AddTaskViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
 
          let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string

          return newText.count <= 30
      }
}

// MARK: PanModalPresentable

extension AddTaskViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(500)
    }
}
