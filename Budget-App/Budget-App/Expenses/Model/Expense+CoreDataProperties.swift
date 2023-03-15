//
//  Expense+CoreDataProperties.swift
//  Budget-App
//
//  Created by Catherine Shing on 3/15/23.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var amount: NSDecimalNumber?
    @NSManaged public var name: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var budget: Budget?

}

extension Expense : Identifiable {

}
