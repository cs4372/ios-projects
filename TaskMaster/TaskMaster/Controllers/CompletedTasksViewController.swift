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
    @IBOutlet weak var deleteTasksButton: UIButton!
    
    var completedTasks: [Task]? {
        didSet {
            if let count = completedTasks?.count {
                let taskText = (count == 1) ? "task" : "tasks"
                let greeting = "You completed \(count) \(taskText)!"
                tasksLabel?.text = greeting
            } else {
                tasksLabel?.text = "You completed 0 tasks!"
            }
            tasksLabel?.textColor = FlatWatermelon()
        }
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    private func setupDeleteTasksButton() {
        deleteTasksButton?.backgroundColor = FlatWhite()
        deleteTasksButton?.layer.cornerRadius = deleteTasksButton.bounds.width / 2
        deleteTasksButton?.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDeleteTasksButton()
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
    
    func deleteCompletedTasks() {
        guard let completedTasks = completedTasks else { return }
        
        for task in completedTasks {
            context.delete(task)
        }
        
        do {
            try context.save()
            loadTasks()
            self.collectionView.reloadData()
        } catch {
            print("Error saving context \(error)")
        }
    }

    @IBAction override func toggleCheckbox(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? TaskCollectionViewCell,
            let collectionView = self.collectionView,
            let indexPath = collectionView.indexPath(for: cell) {
                let task = self.completedTasks?[indexPath.row]
                task!.isCompleted.toggle()
                collectionView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let index = self.completedTasks?.firstIndex(where: { $0 == task }) {
                    self.completedTasks?.remove(at: index)
                    self.saveTasks()
                    collectionView.reloadData()
                }
            }
        }
    }
    
    @IBAction func deleteButtonTap(_ sender: UIButton) {
        AlertHelper.showAlertWithYesNoOptions(title: "Clear completed tasks", message: "Are you sure you want to clear all completed tasks?", over: self, yesHandler: {
            self.deleteCompletedTasks()
        }, noHandler: {
            print("No")
        })
    }
}
