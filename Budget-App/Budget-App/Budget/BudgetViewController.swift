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
    
    @IBAction func saveBudget(_ sender: UIButton) {
        guard let budgetTitleText = budgetTitleTextField.text, !budgetTitleText.isEmpty else {
            print("invalid title")
            return
        }
        guard let budgetAmountText = budgetAmountTextField.text, !budgetAmountText.isEmpty else {
            print("invalid amount")
            return
        }
        let budgetAmount = NSDecimalNumber(string: budgetAmountText)
        
        budgetTitleTextField.text = ""
        budgetAmountTextField.text = ""
        
        let budget = DataManager.shared.setBudget(title: budgetTitleText, amount: budgetAmount)
        budgets.append(budget)
        DataManager.shared.saveContext()
        tableView.reloadData()
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
        cell.expenseLabel?.text = "Amount \(budget.amount!)"
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
