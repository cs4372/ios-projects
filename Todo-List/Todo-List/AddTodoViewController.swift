//
//  AddTodoViewController.swift
//  Todo-List
//
//  Created by Catherine Shing on 2/16/23.
//

import UIKit

class AddTodoViewController: UIViewController {
    
    @IBOutlet weak var todoTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addTodo(_ sender: UIButton) {
        let todosObject = UserDefaults.standard.array(forKey: "todos")
        var todos: [String]
        
        guard let text = todoTextField.text, !text.isEmpty else {
            return
        }
        if let todoList = todosObject as? [String] {
            todos = todoList
            todos.append(todoTextField.text!)
        } else{
            todos = [todoTextField.text!]
        }
        UserDefaults.standard.set(todos, forKey: "todos")
        todoTextField.text = ""
    }
}
