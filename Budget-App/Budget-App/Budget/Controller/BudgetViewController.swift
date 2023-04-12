//
//  BudgetViewController.swift
//  Budget-App
//
//  Created by Catherine Shing on 2/25/23.
//

import UIKit

class BudgetViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var budgetTitleTextField: UITextField!
    @IBOutlet weak var budgetAmountTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var budgets: [Budget] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        budgets = DataManager.shared.getBudgets()
        tableView.reloadData()
    }
    
        @IBAction func saveBudget(_ sender: UIBarButtonItem) {
            guard let budgetTitleText = budgetTitleTextField.text, !budgetTitleText.isEmpty else {
                AlertHelper.showAlert(title: "Invalid title", message: "Please try again", over: self)
                return
        }
        
        if let budgetAmountText = budgetAmountTextField.text, !budgetAmountText.isEmpty,
            let budgetAmount = Decimal(string: budgetAmountText) {
            let budgetNum = NSDecimalNumber(decimal: budgetAmount)
            
            budgetTitleTextField.text = ""
            budgetAmountTextField.text = ""
            
            let budget = DataManager.shared.setBudget(title: budgetTitleText, amount: budgetNum)
            budgets.append(budget)
            DataManager.shared.saveContext()
            tableView.reloadData()
        } else {
            AlertHelper.showAlert(title: "Invalid amount", message: "Please try again", over: self)
        }
    }
    
    @IBSegueAction func openExpenses(_ coder: NSCoder) -> ExpenseViewController? {
        let vc = ExpenseViewController(coder: coder)
        guard let indexPath = tableView.indexPathForSelectedRow else {
          return vc
        }
        let budget = budgets[indexPath.row]
        vc?.budget = budget
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        return vc
    }
}

extension BudgetViewController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        budgets.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BudgetTableViewCell
        let budget = budgets[indexPath.row]
        cell.titleLabel?.text = budget.title!
        cell.expenseLabel?.text = Currency.formatCurrency(amount: budget.amount! as Decimal)
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             budgets.remove(at: indexPath.row)
             tableView.deleteRows(at: [indexPath], with: .fade)
             DataManager.shared.deleteBudget(idx: indexPath.row)
         }
     }
}
