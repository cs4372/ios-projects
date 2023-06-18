//
//  CompletedTasksViewController.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/10/23.
//

import UIKit
import CoreData
import ChameleonFramework

class CompletedTasksViewController: TaskViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tasksLabel: UILabel!
    
    var completedTasks: [Task]? {
        didSet {
            let greeting = "You completed \(completedTasks!.count) tasks!"
            tasksLabel?.text = greeting
            tasksLabel?.textColor = FlatWatermelon()
        }
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        loadTasks()
    }
    
    override func loadTasks(with request: NSFetchRequest<Task> = Task.fetchRequest(), predicate: NSPredicate? = nil) {

        let isCompletedPredicate = NSPredicate(format: "isCompleted == %d", true)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [isCompletedPredicate, additionalPredicate])
        } else {
            request.predicate = isCompletedPredicate
        }
        
        do {
            completedTasks = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        self.collectionView.reloadData()
    }
    
    @IBAction override func toggleCheckbox(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? TaskCollectionViewCell,
            let collectionView = self.collectionView,
            let indexPath = collectionView.indexPath(for: cell) {
                let task = self.completedTasks?[indexPath.row]
                self.completedTasks?.remove(at: indexPath.row)
                task!.isCompleted.toggle()
                saveTasks()
                collectionView.reloadData()
        }
    }
}
