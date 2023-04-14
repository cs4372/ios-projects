//
//  TodoListViewController.swift
//  Todo-List
//
//  Created by Catherine Shing on 2/15/23.
//

import UIKit

class TodoListViewController: UIViewController {
        
    let todoTableView: UITableView = {
         let tableView = UITableView()
         tableView.translatesAutoresizingMaskIntoConstraints = false
         return tableView
     }()
    
    var todos = [Todo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(todoTableView)
        setupUI()
        todoTableView.delegate = self
        todoTableView.dataSource = self
        
        todoTableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoCell") // Register a reusable cell for the table view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        todos = loadTodos()
        todoTableView.reloadData()
    }
    
    private func setupUI() {
          view.backgroundColor = .white
          todoTableView.largeContentTitle = "Tasks"
          NSLayoutConstraint.activate([
              todoTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
              todoTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
              todoTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
              todoTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
          ])
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

// MARK: - UITableViewDelegate, UITableViewDataSource

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = todoTableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoTableViewCell
        let todo = todos[indexPath.row]
        cell.todoTextLabel.text = todo.title
        
        cell.layer.borderColor = UIColor.systemBlue.cgColor
        cell.layer.borderWidth = 3
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
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

        let addTodoVC = AddTodoViewController()
        addTodoVC.todo = todo
        navigationController?.pushViewController(addTodoVC, animated: true)
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 80
    }
    
    internal func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         let sectionHeaderView = SectionHeaderView()
         sectionHeaderView.titleLabel.text = "Tasks"
         return sectionHeaderView
     }

     internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 40
     }
}
