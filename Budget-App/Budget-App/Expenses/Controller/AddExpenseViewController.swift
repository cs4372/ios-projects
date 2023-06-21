//
//  AddExpenseViewController.swift
//  Budget-App
//
//  Created by Catherine Shing on 4/9/23.
//

import UIKit

protocol AddExpenseDelegate: AnyObject {
    func didAddExpense(expenseTitle: String, amount: String)
}

class AddExpenseViewController: UIViewController, UITextFieldDelegate {
    
    weak var delegate: AddExpenseDelegate?
    
    @IBOutlet weak var expenseTitleTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expenseTitleTextField.delegate = self
        amountTextField.delegate = self
        
        expenseTitleTextField.keyboardType = .default
        amountTextField.keyboardType = .decimalPad
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        expenseTitleTextField.resignFirstResponder()
        amountTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func saveExpense(_ sender: UIBarButtonItem) {
        guard let expenseText = expenseTitleTextField.text,
              !expenseText.isEmpty else {
            AlertHelper.showAlert(title: "Invalid expense", message: "Please try again", over: self)
            return
        }
        guard let amountText = amountTextField.text, !amountText.isEmpty,
              amountText.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil else {
            AlertHelper.showAlert(title: "Invalid amount", message: "Please try again", over: self)
            return
        }
        
        delegate?.didAddExpense(expenseTitle: expenseText, amount: amountText)
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
}

