//
//  CalendarViewController.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/11/23.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    
    var selectedTasks: [Task]?
    var tasksByDate: [String: [Task]]?
    var selectedDate: String? = DateHelper.formattedFullDate(from: Date())
    var dateKeys: [String]?
            
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
        tableView.dataSource = self
        calendar.appearance.titleDefaultColor = UIColor(named: "CalenderDateColor")
        reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadData()
    }

    func reloadData() {
        tasksByDate = DataManager.shared.tasksByDate
        selectedTasks = getTasks(date: selectedDate!)
        dateKeys = Array(tasksByDate!.keys)
        self.calendar.reloadData()
        self.tableView.reloadData()
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = DateHelper.formattedFullDate(from: date)
        selectedTasks = getTasks(date: selectedDate!)
        self.tableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = DateHelper.formattedFullDate(from: date)
        
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
           }
            return nil
       }
}
