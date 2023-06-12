//
//  CalendarViewController.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/11/23.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    @IBOutlet weak var calendar: FSCalendar!
//    @IBOutlet weak var tableView: UITableView!
        
//    var tasksByDate: [String: [Task]] = [:]
    
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
        
        
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "cell")

//        loadTasks()
//        groupTasksByDate()
//        tableView.reloadData()
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
