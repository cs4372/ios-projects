//
//  CalendarViewController+Extensions.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/18/23.
//

import UIKit

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
