//
//  DateHelper.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/7/23.
//

import Foundation

struct DateHelper {
    static func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM EEE"
        return dateFormatter.string(from: date)
    }
}
