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
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    
    var editTask: Task?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    weak var delegate: TaskViewVCDelegate?
        
    override func viewDidLoad() {
        searchTextField.delegate = self
        
        setupUI()
        
        if let editTask {
            dueDate.date = editTask.dueDate!
            searchTextField.text = editTask.title!
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextField.becomeFirstResponder()
    }
    
    private func setupUI() {
        saveButton.layer.cornerRadius = 5
        saveButton.backgroundColor = FlatWatermelon()
    }
    
    @IBAction func saveTask(_ sender: UIButton) {
        guard let text = searchTextField.text, !text.isEmpty else {
            return
        }
        
        if let editTask {
             editTask.title = searchTextField.text
             editTask.dueDate = dueDate.date
             delegate?.didEditTask(editTask)
         } else {
             let newTask = Task(context: context)
             newTask.title = searchTextField.text
             newTask.dueDate = dueDate.date
             let color = RandomFlatColorWithShade(.light)
             let lightenedColor = color.lighten(byPercentage: 0.3)
             newTask.taskColor = (lightenedColor?.hexValue())!
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
