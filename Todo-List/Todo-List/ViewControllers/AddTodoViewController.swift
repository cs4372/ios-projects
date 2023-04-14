//
//  AddTodoViewController.swift
//  Todo-List
//
//  Created by Catherine Shing on 2/16/23.
//

import UIKit

class AddTodoViewController: UIViewController {
        
    var todo: Todo?
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter task"
        textField.borderStyle = .roundedRect
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        populateTodoData()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(addTodo))
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func populateTodoData() {
          if let todo = todo {
              textField.text = todo.title
          }
      }

    @IBAction func addTodo(_ sender: UIButton) {
        if let title = textField.text, !title.isEmpty {
            var todos = loadTodos()
            if var todo = todo {
                todo.title = title
                if let index = todos.firstIndex(where: { $0.id == todo.id }) {
                    todos[index] = todo
                }
            } else {
                let newTodo = Todo(title: title)
                todos.append(newTodo)
            }
            saveTodos(todos)
            textField.text = ""
        }
    }
    
    func loadTodos() -> [Todo] {
        if let data = UserDefaults.standard.data(forKey: "todos") {
            let decoder = JSONDecoder()
            if let savedTodos = try? decoder.decode([Todo].self, from: data) {
                return savedTodos
            }
        }
        return []
    }

    func saveTodos(_ todos: [Todo]) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(todos) {
            UserDefaults.standard.set(encodedData, forKey: "todos")
        }
    }
}
