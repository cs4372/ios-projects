//
//  AddTodoViewController.swift
//  Todo-List
//
//  Created by Catherine Shing on 2/16/23.
//

import UIKit

class AddTodoViewController: UIViewController {
    
    @IBOutlet weak var todoTextField: UITextField!
    
    var todo: Todo?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let todo = todo {
            todoTextField.text = todo.title
        }
    }

    @IBAction func addTodo(_ sender: UIButton) {
        if let title = todoTextField.text, !title.isEmpty {
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
            navigationController?.popViewController(animated: true)
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
