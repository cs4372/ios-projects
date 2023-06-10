//
//  ViewController.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/6/23.
//

import UIKit
import CoreData
import ChameleonFramework

class TaskViewController: UIViewController, TaskViewVCDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasks: [Task]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        addTaskButton?.layer.cornerRadius = addTaskButton.bounds.width / 2
        setupAddTaskButton()
        loadTasks()
        setupUserNameLabel()
        setupDateLabel()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    private func setupUserNameLabel() {
        if let savedUserName = UserDefaults.standard.string(forKey: "UserName") {
            let greeting = "Hi \(savedUserName)!"
            nameLabel?.text = greeting
            nameLabel?.textColor = FlatWatermelon()
        }
    }

    private func setupDateLabel() {
        let dateMessage = "Today is \(DateHelper.formattedDate(from: Date()))"
        dateLabel?.text = dateMessage
        dateLabel?.textColor = FlatSkyBlue()
    }
    
    private func setupAddTaskButton() {
        addTaskButton?.layer.cornerRadius = addTaskButton.bounds.width / 2
        addTaskButton?.clipsToBounds = true
    }
    
    // MARK: Task Operations
    
    func didAddTask(_ task: Task) {
        self.tasks?.append(task)
        self.saveTasks()
        self.collectionView.reloadData()
    }
    
    func didEditTask(_ task: Task) {
        self.saveTasks()
        self.collectionView.reloadData()
    }
    
    @IBAction func addTask(_ sender: UIButton) {
        let addTaskViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
        addTaskViewController.delegate = self

        presentPanModal(addTaskViewController)
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
    
    func loadTasks(with request: NSFetchRequest<Task> = Task.fetchRequest()) {
        let sortByDueDate = NSSortDescriptor(key: "dueDate", ascending: true)
          request.sortDescriptors = [sortByDueDate]
        
        do {
            tasks = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        self.collectionView.reloadData()
    }
    
    func saveTasks() {
        do {
            try self.context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
}

// MARK: UICollectionViewDataSource

extension TaskViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if tasks?.count == 0 {
            collectionView.setEmptyView(title: "You don't have any tasks yet!", message: "Click the + button to add some tasks")
        } else {
            collectionView.restore()
        }
        return tasks?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCollectionViewCell", for: indexPath) as! TaskCollectionViewCell
        
        if let task = tasks?[indexPath.row] {
            cell.setup(with: task)
        }
        
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension TaskViewController: UICollectionViewDelegateFlowLayout {
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 200)
    }
}

// MARK: UICollectionViewDelegate

extension TaskViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = self.createEditAction(for: indexPath)
            let deleteAction = self.createDeleteAction(for: indexPath)
            
            return UIMenu(title: "", children: [editAction, deleteAction])
        }
        
        return configuration
    }
    
    private func createEditAction(for indexPath: IndexPath) -> UIAction {
        let editAction = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { [weak self] action in
            guard let self = self else { return }
            
            if let editItem = self.tasks?[indexPath.row] {
                let addTaskCV = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
                let task = self.tasks?[indexPath.row]
                addTaskCV.delegate = self
                
                if let currentTask = task {
                    addTaskCV.editTask = currentTask
                }
                
                self.presentPanModal(addTaskCV)
            }
        }
        
        return editAction
    }
    
    private func createDeleteAction(for indexPath: IndexPath) -> UIAction {
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] action in
            guard let self = self else { return }
            
            if let deleteItem = self.tasks?[indexPath.row] {
                self.context.delete(deleteItem)
                self.tasks?.remove(at: indexPath.row)
                self.saveTasks()
                self.collectionView.reloadData()
            }
        }
        
        return deleteAction
    }
}
