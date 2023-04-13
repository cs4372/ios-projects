//
//  TodoListViewController.swift
//  Todo-List
//
//  Created by Catherine Shing on 2/15/23.
//

import UIKit

class TodoListViewController: UIViewController {
    @IBOutlet weak var todoTableView: UITableView!
    
    var todos = [Todo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        todoTableView.delegate = self
        todoTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        todos = loadTodos()
        todoTableView.reloadData()
    }
    
    // MARK: Decode the Data object into an array of Todo objects
    
    func loadTodos() -> [Todo] {
        if let data = UserDefaults.standard.data(forKey: "todos") {
            let decoder = JSONDecoder()
            if let savedTodos = try? decoder.decode([Todo].self, from: data) {
                return savedTodos
            }
        }
        return []
    }
    
    // MARK: Encoding Todo objects into JSON data to save in UserDefaults
    
    func saveTodos(_ todos: [Todo]) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(todos) {
            UserDefaults.standard.set(encodedData, forKey: "todos")
        }
    }
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! TodoTableViewCell
        let todo = todos[indexPath.row]
        cell.todoTextLabel?.text = todo.title
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveTodos(todos)
            todoTableView.reloadData()
        }
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = todos[indexPath.row]

        if let addTodoVC = storyboard?.instantiateViewController(identifier: "EditTodoSegue") as? AddTodoViewController {
            addTodoVC.todo = todo
            navigationController?.pushViewController(addTodoVC, animated: true)
        }
    }
}
