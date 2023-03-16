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
            amountLabel.text = "$\(budget.amount!)"
            expenses = DataManager.shared.getExpenses(budget: budget)
            let totalExpenses = calculateTotalExpenses(expenses: expenses)
            spentLabel.text = "$\(totalExpenses)"
            checkOverBudget(totalExpenses: totalExpenses, budget: budget)
            tableView.reloadData()
        }
    }
    
    func calculateTotalExpenses(expenses: [Expense]) -> Decimal {
        return expenses.reduce(0) { $0 + ($1.amount as! Decimal) }
    }
        
    @IBAction func saveExpenses(_ sender: UIButton) {
        guard let budget = budget else {
            return
        }
        guard let expenseText = expenseTextField.text, !expenseText.isEmpty else {
            AlertHelper.showAlert(title: "Invalid expense", message: "Please try again", over: self)
            return
        }
        guard let amountText = amountTextField.text, !amountText.isEmpty, let amountNumber = Double(amountText) else {
            AlertHelper.showAlert(title: "Invalid amount", message: "Please try again", over: self)
            return
        }
        let budgetAmount = NSDecimalNumber(string: amountText)
        let currDate = Date()
                
        expenseTextField.text = ""
        amountTextField.text = ""
        
        let expense = DataManager.shared.setExpense(name: expenseText, amount: budgetAmount, timestamp: currDate, budget: budget)
        expenses.append(expense)
        DataManager.shared.saveContext()
        
        let totalExpenses = calculateTotalExpenses(expenses: expenses)
        spentLabel.text = "$\(totalExpenses)"
        
        checkOverBudget(totalExpenses: totalExpenses, budget: budget)
        
        tableView.reloadData()
    }
    
    private func checkOverBudget(totalExpenses: Decimal, budget: Budget) {
        if totalExpenses > budget.amount as! Decimal {
            AlertHelper.showAlert(title: "You've gone over budget!", message: "Watch your spending", over: self)
            spentLabel.textColor = UIColor.red
        } else {
            spentLabel.textColor = UIColor.green
        }
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
        cell.amountLabel?.text = "$\(expense.amount!)"
        let date = expense.timestamp!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: date)
        cell.timestampLabel?.text = dateString
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
             let totalExpenses = calculateTotalExpenses(expenses: expenses)
             spentLabel.text = "$\(totalExpenses)"
             checkOverBudget(totalExpenses: totalExpenses, budget: budget)
         }
     }
}
