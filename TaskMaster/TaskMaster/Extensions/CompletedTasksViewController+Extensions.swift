//
//  CompletedTasksViewController+.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/18/23.
//

import UIKit
import CoreData

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
       let editAction = UIAction(title: "Set it to incomplete", image: UIImage(systemName: "pencil")) { [weak self] _ in
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
       let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
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

// MARK: UISearchBarDelegate

extension CompletedTasksViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            let request: NSFetchRequest<Task> = Task.fetchRequest()
            let titlePredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.predicate = titlePredicate
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadTasks(with: request, predicate: titlePredicate)
        }
        searchBar.resignFirstResponder()
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
