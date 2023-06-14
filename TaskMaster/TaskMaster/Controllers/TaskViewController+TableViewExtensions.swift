//
//  TaskViewController+TableViewExtensions.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/14/23.
//

import UIKit

extension TaskViewController: UITableViewDataSource {
    
    func groupTasksByDate() {
        tasksByDate = [:]
        
        if let tasks = tasks {
            for task in tasks {
                guard let dueDate = task.dueDate else { continue }
                
                let dateString = dateFormatter.string(from: dueDate)
                
                if tasksByDate[dateString] == nil {
                    tasksByDate[dateString] = [task]
                } else {
                    tasksByDate[dateString]?.append(task)
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
          if tasksByDate.isEmpty {
              tableView.setEmptyView(title: "You don't have any tasks yet!", message: "Click the + button to add some tasks")
          } else {
              tableView.restore()
          }
          
          return tasksByDate.count
      }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sortedTasksByDate = tasksByDate.keys.sorted(by: { dateFormatter.date(from: $0)! < dateFormatter.date(from: $1)! })
        let date = sortedTasksByDate[section]
        
        if let tasks = tasksByDate[date] {
            return tasks.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionDates = Array(tasksByDate.keys).sorted()

        let sectionDateString = sectionDates[section]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let sectionDate = dateFormatter.date(from: sectionDateString) {
            return dateFormatter.string(from: sectionDate)
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, completionHandler) in
            let addTaskCV = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTaskViewController") as! AddTaskViewController
            let sectionDates = Array(self.tasksByDate.keys).sorted()
            let sectionDateString = sectionDates[indexPath.section]
            let tasksForSection = self.tasksByDate[sectionDateString]
            
            let task = tasksForSection?[indexPath.row]
            addTaskCV.delegate = self

            if let currentTask = task {
                addTaskCV.editTask = currentTask
            }

            self.presentPanModal(addTaskCV)
            completionHandler(true)
        }
        editAction.backgroundColor = .flatSkyBlue()
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            let sectionDates = Array(self.tasksByDate.keys).sorted()
            let sectionDateString = sectionDates[indexPath.section]
            
            var tasksForSection = self.tasksByDate[sectionDateString]
            
            if let deleteItem = tasksForSection?[indexPath.row] {
                tasksForSection?.remove(at: indexPath.row)
                self.tasksByDate[sectionDateString] = tasksForSection
                
                if var tasksOnDueDate = tasksByDate[sectionDateString] {
                    if let taskIndex = tasksOnDueDate.firstIndex(of: deleteItem) {
                        tasksOnDueDate.remove(at: taskIndex)
                        tasksByDate[sectionDateString] = tasksOnDueDate
                    }
                }
                
                if tasksForSection?.isEmpty ?? false {
                    self.tasksByDate.removeValue(forKey: sectionDateString)
                }
                
                self.context.delete(deleteItem)
                self.saveTasks()
                loadTasks()
                self.tableView.reloadData()
                self.collectionView.reloadData()
            }
            
            completionHandler(true)
        }
        deleteAction.backgroundColor = .flatWatermelon()
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }
}

extension TaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionDates = Array(self.tasksByDate.keys).sorted()
        let sectionDateString = sectionDates[indexPath.section]
        let tasksForSection = self.tasksByDate[sectionDateString]
        let task = tasksForSection?[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        
        let sectionDates = Array(tasksByDate.keys).sorted()
        let sectionDateString = sectionDates[indexPath.section]
        let tasksForSection = tasksByDate[sectionDateString]
        
        if let task = tasksForSection?[indexPath.row] {
            cell.setup(with: task)
        }
        
        return cell
    }
}

