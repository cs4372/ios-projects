//
//  TabBarController.swift
//  Todo-List
//
//  Created by Catherine Shing on 4/13/23.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let todosVC = TodoListViewController()
        let addTodoVC = AddTodoViewController()

        // Embed the TodosViewController and AddTodoViewController in a UINavigationController
        let todosNavVC = UINavigationController(rootViewController: todosVC)
        let addTodoNavVC = UINavigationController(rootViewController: addTodoVC)

        self.viewControllers = [todosNavVC, addTodoNavVC]
        
        todosNavVC.tabBarItem.title = "Todos"
        addTodoNavVC.tabBarItem.title = "Add Todo"
        
        todosNavVC.tabBarItem.image = UIImage(named: "list.bullet")
        addTodoNavVC.tabBarItem.image = UIImage(named: "plus")
    }
}
