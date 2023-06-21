//
//  ExpenseViewController.swift
//  Budget-App
//
//  Created by Catherine Shing on 2/25/23.
//

import UIKit
import Charts

class ExpenseViewController: UIViewController, UITableViewDelegate, AddExpenseDelegate {
    
    var budget: Budget?
        
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var spentLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!
    private var expenses: [Expense] = []
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        setupBudgetLabels()
        setupExpenses()
        setupPieChart()
    }
    
    private func setupBudgetLabels() {
        guard let budget = budget else { return }
        budgetLabel.text = budget.title
        amountLabel.text = Currency.formatCurrency(amount: budget.amount! as Decimal)
    }
    
    private func setupExpenses() {
        guard let budget = budget else { return }
        expenses = DataManager.shared.getExpenses(budget: budget)
        let totalExpenses = calculateTotalExpenses(expenses: expenses)
        spentLabel.text = Currency.formatCurrency(amount: totalExpenses)
        checkOverBudget(totalExpenses: totalExpenses, budget: budget)
        tableView.reloadData()
    }
    
    private func setupPieChart() {
        let dataEntries = expenses.enumerated().map { (idx, expense) in
            return PieChartDataEntry(value: expenses[idx].amount as! Double, label: expenses[idx].name)
        }
        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        dataSet.colors = expenses.enumerated().map { (idx, _) in
            return UIColor(hue: CGFloat(idx) / CGFloat(expenses.count), saturation: 0.8, brightness: 0.8, alpha: 1)
        }
        dataSet.valueFont = UIFont.boldSystemFont(ofSize: 15)
        let data = PieChartData(dataSet: dataSet)
        self.pieChartView.data = data
        self.pieChartView.centerText = expenses.isEmpty ? "No expenses." : ""
        self.pieChartView.legend.enabled = true
        self.pieChartView.legend.direction = .leftToRight
        self.pieChartView.legend.horizontalAlignment = .left
        self.pieChartView.legend.verticalAlignment = .bottom
        self.pieChartView.legend.font = UIFont.systemFont(ofSize: 14)
        self.pieChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
        self.pieChartView.notifyDataSetChanged()
    }
    
    private func calculateTotalExpenses(expenses: [Expense]) -> Decimal {
        return expenses.reduce(0) { $0 + (($1.amount ?? 0) as Decimal)}
    }
    
    // MARK: - AddExpenseDelegate Method

    func didAddExpense(expenseTitle: String, amount: String) {
        guard let budget = budget else { return }
        let budgetAmount = NSDecimalNumber(string: amount)
        let currDate = Date()
        
        let expense = DataManager.shared.setExpense(name: expenseTitle, amount: budgetAmount, timestamp: currDate, budget: budget)
        expenses.append(expense)
        DataManager.shared.saveContext()
        
        let totalExpenses = calculateTotalExpenses(expenses: expenses)
        spentLabel.text = Currency.formatCurrency(amount: totalExpenses)
                
        self.checkOverBudget(totalExpenses: totalExpenses, budget: budget)
        tableView.reloadData()
        setupPieChart()
      }
    
    private func checkOverBudget(totalExpenses: Decimal, budget: Budget) {
        if totalExpenses > budget.amount! as Decimal {
            AlertHelper.showAlert(title: "You've gone over budget!", message: "Watch your spending", over: self)
            spentLabel.textColor = UIColor.red
        } else {
            spentLabel.textColor = UIColor.systemGreen
            spentLabel.font = UIFont.boldSystemFont(ofSize: 17)
        }
    }
}

// MARK: - UITableViewDataSource to set up the data source for the table view

extension ExpenseViewController: UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        expenses.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ExpenseTableViewCell else {
            fatalError("Unable to dequeue ExpenseTableViewCell")
        }
        let expense = expenses[indexPath.row]
        cell.expenseLabel.text = expense.name ?? ""
        cell.amountLabel.text = Currency.formatCurrency(amount: expense.amount! as Decimal)
        cell.timestampLabel.text = formatDate(date: expense.timestamp)
        return cell
    }

    private func formatDate(date: Date?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
            case .delete:
                guard let budget = budget else { return }
                expenses.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                DataManager.shared.deleteExpense(idx: indexPath.row, budget: budget)
                let totalExpenses = calculateTotalExpenses(expenses: expenses)
            spentLabel.text = Currency.formatCurrency(amount: totalExpenses)
            expenses = DataManager.shared.getExpenses(budget: budget)
            default:
                break
            }
     }
    
    // MARK: - Navigation to AddExpenseViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addExpenseSegue" {
            if let addExpenseVC = segue.destination as? AddExpenseViewController {
                addExpenseVC.delegate = self
            }
        }
    }
}
