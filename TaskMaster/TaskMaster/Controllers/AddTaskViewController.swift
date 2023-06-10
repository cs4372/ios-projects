//
//  AddTaskController.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/7/23.
//

import UIKit
import PanModal
import ChameleonFramework

protocol TaskViewVCDelegate: AnyObject {
    func didAddTask(_ task: Task)
    func didEditTask(_ task: Task)
}

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    
    var editTask: Task?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    weak var delegate: TaskViewVCDelegate?
        
    override func viewDidLoad() {
        titleInput.delegate = self
        
        setupUI()
        
        if let editTask {
            dueDate.date = editTask.dueDate!
            titleInput.text = editTask.title!
        }
    }
    
    private func setupUI() {
        saveButton.layer.cornerRadius = 5
        saveButton.backgroundColor = FlatWatermelon()
    }
    
    @IBAction func saveTask(_ sender: UIButton) {
        guard let text = titleInput.text, !text.isEmpty else {
            return
        }
        
        if let editTask {
             editTask.title = titleInput.text
             editTask.dueDate = dueDate.date
             delegate?.didEditTask(editTask)
         } else {
             let newTask = Task(context: context)
             newTask.title = titleInput.text
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
