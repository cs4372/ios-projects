//
//  Task+CoreDataProperties.swift
//  TaskMaster
//
//  Created by Catherine Shing on 6/6/23.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var title: String?
    @NSManaged public var dueDate: Date?
    @NSManaged public var isCompleted: Bool

}

extension Task : Identifiable {

}
