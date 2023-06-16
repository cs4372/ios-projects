//
//  DataManager.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/15/23.
//

import UIKit

class DataManager {
    static let shared = DataManager()
    
    var tasksByDate: [String: [Task]] = [:]
        
    func groupTasksByDate(tasks: [Task]) {
        tasksByDate = [:]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for task in tasks {
            guard let dueDate = task.dueDate else { continue }
            
            let dateString = DateHelper.formattedFullDate(from: dueDate)
            
            if tasksByDate[dateString] == nil {
                tasksByDate[dateString] = [task]
            } else {
                tasksByDate[dateString]?.append(task)
            }
        }
    }
}
