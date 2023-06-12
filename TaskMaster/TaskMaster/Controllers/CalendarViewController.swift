//
//  CalendarViewController.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/11/23.
//

import UIKit
import FSCalendar

class CalendarViewController: TaskViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
        
    var tasksByDate: [String: [Task]] = [:]
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var eventDates = ["2023-06-14", "2023-06-15"]

    override func viewDidLoad() {
        super.viewDidLoad()

        calendar.delegate = self
        calendar.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        loadTasks()
        groupTasksByDate()
        tableView.reloadData()
        print("tasks==>", tasks)
        print("tasksByDate==>", tasksByDate)
    }
    
    func groupTasksByDate() {
        if let tasks {
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
    
//    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
//        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
//
//        let dateString = dateFormatter.string(from: date)
//        let hasEvent = eventDates.contains(dateString)
//        cell.eventIndicator.isHidden = !hasEvent
//
//        return cell
//    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = dateFormatter.string(from: date)
        return eventDates.contains(dateString) ? 1 : 0
    }
}

extension CalendarViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tasksByDate.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dates = Array(tasksByDate.keys)
        let date = dates[section]
        
        if let tasks = tasksByDate[date] {
            print("Number of tasks for date \(date): \(tasks.count)")
            return tasks.count
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionDates = Array(tasksByDate.keys)
        let sectionDateString = sectionDates[section]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let sectionDate = dateFormatter.date(from: sectionDateString) {
            return dateFormatter.string(from: sectionDate)
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let sectionDates = Array(tasksByDate.keys)
        let sectionDateString = sectionDates[indexPath.section]
        let tasksForSection = tasksByDate[sectionDateString]
        
        let task = tasksForSection?[indexPath.row]
        cell.textLabel?.text = task?.title
        
        return cell
    }
}

extension CalendarViewController: UITableViewDelegate {
    
}
