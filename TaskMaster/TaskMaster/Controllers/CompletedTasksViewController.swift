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
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        loadTasks()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
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

 // MARK: UICollectionViewDataSource

extension CompletedTasksViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if completedTasks?.count == 0 {
            collectionView.setEmptyView(title: "You don't have any completed tasks yet!", message: "Go back to the Tasks screen to add some tasks")
        } else {
            collectionView.restore()
        }
        return completedTasks?.count ?? 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCollectionViewCell", for: indexPath) as! TaskCollectionViewCell

        if let task = completedTasks?[indexPath.row] {
            cell.setup(with: task)
        }

        return cell
    }
}

// MARK: UICollectionViewDelegate

extension CompletedTasksViewController {

    override func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = self.createEditAction(for: indexPath)
            let deleteAction = self.createDeleteAction(for: indexPath)

            return UIMenu(title: "", children: [editAction, deleteAction])
        }

        return configuration
    }
    
    private func createEditAction(for indexPath: IndexPath) -> UIAction {
        let editAction = UIAction(title: "Set it to incomplete", image: UIImage(systemName: "pencil")) { [weak self] action in
            guard let self = self else { return }
            
            if let task = self.completedTasks?[indexPath.row] {
                task.isCompleted = false
                self.completedTasks?.remove(at: indexPath.row)
                self.saveTasks()
                self.collectionView.reloadData()
            }
        }
        
        return editAction
    }
    
    private func createDeleteAction(for indexPath: IndexPath) -> UIAction {
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] action in
            guard let self = self else { return }
            
            if let deleteItem = self.completedTasks?[indexPath.row] {
                self.context.delete(deleteItem)
                self.completedTasks?.remove(at: indexPath.row)
                self.saveTasks()
                self.collectionView.reloadData()
            }
        }
        
        return deleteAction
    }
}

extension CompletedTasksViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = titlePredicate
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadTasks(with: request, predicate: titlePredicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadTasks()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
