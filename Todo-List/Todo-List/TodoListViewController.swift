//
//  TodoListViewController.swift
//  Todo-List
//
//  Created by Catherine Shing on 2/15/23.
//

import UIKit

class TodoListViewController: UIViewController {
    @IBOutlet weak var todoTableView: UITableView!
    
    var todos = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        todoTableView.delegate = self
        todoTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let todoObject = UserDefaults.standard.array(forKey: "todos")
        if let todoItems = todoObject as? [String] {
            todos = todoItems
        }
        UserDefaults.standard.set(todos, forKey: "todos")
        todoTableView.reloadData()
    }
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TodoTableViewCell
        cell.todoTextLabel?.text = todos[indexPath.row]
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            UserDefaults.standard.set(todos, forKey: "todos")
        }
    }
}
