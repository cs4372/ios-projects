//
//  ExpenseViewController.swift
//  Budget-App
//
//  Created by Catherine Shing on 2/25/23.
//

import UIKit

class ExpenseViewController: UIViewController, UITableViewDelegate {
    var budget: Budget?
    
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var spentLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var expenses: [Expense] = []

    @IBOutlet weak var expenseTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if let budget = budget {
            budgetLabel.text = budget.title!
            amountLabel.text = "Total \(budget.amount!)"
            expenses = DataManager.shared.getExpenses(budget: budget)
            tableView.reloadData()
            }
        }
        
    @IBAction func saveExpenses(_ sender: UIButton) {
        guard let budget = budget else {
            return
        }
        guard let expenseText = expenseTextField.text, !expenseText.isEmpty else {
            print("invalid expense")
            return
        }
        guard let amountText = amountTextField.text, !amountText.isEmpty else {
            print("invalid amount")
            return
        }
        let budgetAmount = NSDecimalNumber(string: amountText)
        
        expenseTextField.text = ""
        amountTextField.text = ""
        
        let expense = DataManager.shared.setExpense(name: expenseText, amount: budgetAmount, budget: budget)
        expenses.append(expense)
        DataManager.shared.saveContext()
        tableView.reloadData()
    }
}

extension ExpenseViewController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        expenses.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ExpenseTableViewCell
        let expense = expenses[indexPath.row]
        cell.expenseLabel?.text = expense.name!
        cell.amountLabel?.text = "Amount \(expense.amount!)"
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             guard let budget = budget else {
                 return
             }
             expenses.remove(at: indexPath.row)
             tableView.deleteRows(at: [indexPath], with: .fade)
             DataManager.shared.deleteExpense(idx: indexPath.row, budget: budget)
         }
     }
}

