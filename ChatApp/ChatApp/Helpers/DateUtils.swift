//
//  DateUtils.swift
//  ChatApp
//
//  Created by Catherine Shing on 5/23/23.
//

import Foundation

struct DateUtils {
    static func convertTimestampToString(timestamp: TimeInterval) -> String {
        let currentDate = Date()
        let date = Date(timeIntervalSince1970: timestamp)
        
        let dateFormatter = DateFormatter()
        
        if Calendar.current.isDate(date, inSameDayAs: currentDate) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        }
        
        if let daysAgo = Calendar.current.dateComponents([.day], from: date, to: currentDate).day, daysAgo < 7 {
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date)
        }
        
        dateFormatter.dateFormat = "M/d/yy"
        return dateFormatter.string(from: date)
    }
}
