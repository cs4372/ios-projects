//
//  CalendarViewController.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/11/23.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate {
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    
    var selectedTasks:[Task]? = nil
    var tasksByDate: [String: [Task]]?
    var selectedDate: String?
    var dateKeys: [String]? = nil
            
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView?.reloadData()

        if let tasksByDate = tasksByDate {
            dateKeys = Array(tasksByDate.keys)
        }
        calendar.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.delegate = self
        calendar.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        
        if let tasksByDate = tasksByDate {
            dateKeys = Array(tasksByDate.keys)
        }
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        selectedDate = dateFormatter.string(from: date)
        selectedTasks = getTasks(date: selectedDate!)
        self.tableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = dateFormatter.string(from: date)
        
        if let dateKeys {
            if dateKeys.contains(dateString) {
                return 1
            }
        }
        return 0
    }
    
    func getTasks(date dateString: String) -> [Task]? {
           if let tasks = tasksByDate?[dateString] {
               return tasks
           } else {
               return nil
           }
       }
}

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell", for: indexPath) as! CalendarTableViewCell
        
        if let task = selectedTasks?[indexPath.row] {
            cell.setup(with: task)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if selectedTasks == nil {
              tableView.setEmptyView(title: "You don't have any tasks on this date!", message: "")
          } else {
              tableView.restore()
              return selectedDate
          }
        return nil
    }
}
