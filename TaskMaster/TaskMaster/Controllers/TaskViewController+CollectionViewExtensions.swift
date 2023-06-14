//
//  TaskViewController+CollectionViewExtensions.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/14/23.
//

import UIKit

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
                guard let dueDate = deleteItem.dueDate else { return }
                
                let dateString = dateFormatter.string(from: dueDate)

                if var tasksOnDueDate = tasksByDate[dateString] {
                    if let taskIndex = tasksOnDueDate.firstIndex(of: deleteItem) {
                        tasksOnDueDate.remove(at: taskIndex)
                        tasksByDate[dateString] = tasksOnDueDate
                        
                        if tasksOnDueDate.isEmpty {
                            tasksByDate.removeValue(forKey: dateString)
                        }
                    }
                }
                
                self.context.delete(deleteItem)
                self.tasks?.remove(at: indexPath.row)
                self.saveTasks()
                self.collectionView.reloadData()
                self.tableView.reloadData()
            }
        }
        
        return deleteAction
    }
}

