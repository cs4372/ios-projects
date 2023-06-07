//
//  ViewController.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/6/23.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addTaskButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasks: [Task]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        addTaskButton.layer.cornerRadius = addTaskButton.bounds.width / 2
        setupAddTaskButton()
        loadTasks()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    private func setupAddTaskButton() {
        addTaskButton.layer.cornerRadius = addTaskButton.bounds.width / 2
        addTaskButton.clipsToBounds = true
    }
    
    @IBAction func addTask(_ sender: UIButton) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Task", style: .default) { (action) in
            let newTask = Task(context: self.context)
            newTask.title = textField.text!
            newTask.dueDate = Date()
            newTask.isCompleted = false

            self.tasks?.append(newTask)
            self.saveTasks()
            self.collectionView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func toggleCheckbox(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? TaskCollectionViewCell,
            let collectionView = self.collectionView,
            let indexPath = collectionView.indexPath(for: cell) {
                let task = tasks?[indexPath.row]
                task!.isCompleted.toggle()
                saveTasks()
                collectionView.reloadData()
        }
    }
    
    func saveTasks() {
        do {
            try self.context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadTasks(with request: NSFetchRequest<Task> = Task.fetchRequest()) {
        do {
            tasks = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        self.collectionView.reloadData()
    }
}

// MARK: UICollectionViewDataSource

extension TaskViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tasks?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCollectionViewCell", for: indexPath) as! TaskCollectionViewCell
        
        if let task = tasks?[indexPath.row] {
            cell.taskLabel?.text = task.title ?? "No Tasks Added Yet"
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM EEE"

            let formattedDate = dateFormatter.string(from: date)
            cell.DateLabel?.text = formattedDate
            
            let checkboxImage = task.isCompleted ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
            cell.checkboxButton.setImage(checkboxImage, for: .normal)
        }

        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension TaskViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 220)
    }
}

// MARK: UICollectionViewDelegate

extension TaskViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash")) { action in
                
                if let deleteItem = self.tasks?[indexPath.row] {
                    self.context.delete(deleteItem)
                    self.tasks?.remove(at: indexPath.row)
                    self.saveTasks()
                    self.collectionView.reloadData()
                }
            }
            
            return UIMenu(title: "", children: [deleteAction])
        }
        return configuration
    }
}
