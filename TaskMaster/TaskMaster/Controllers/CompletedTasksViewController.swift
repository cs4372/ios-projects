//
//  CompletedTasksViewController.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/10/23.
//

import UIKit
import CoreData

class CompletedTasksViewController: TaskViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var completedTasks: [Task]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        loadTasks()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        loadTasks()
    }
    
    override func loadTasks(with request: NSFetchRequest<Task> = Task.fetchRequest()) {

        request.predicate = NSPredicate(format: "isCompleted == %d", true)
        
        do {
            completedTasks = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        self.collectionView.reloadData()
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
