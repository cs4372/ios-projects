//
//  DataManager.swift
//  Budget-App
//
//  Created by Catherine Shing on 2/26/23.
//

import Foundation
import CoreData

class DataManager {
    
    static let shared = DataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Budget_App")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func setBudget(title: String, amount: NSDecimalNumber) -> Budget {
        let budget = Budget(context: persistentContainer.viewContext)
        budget.title = title
        budget.amount = amount
        return budget
    }
    
    func setExpense(name: String, amount: NSDecimalNumber, budget: Budget) -> Expense {
        let expense = Expense(context: persistentContainer.viewContext)
        expense.name = name
        expense.amount = amount
        expense.budget = budget
        return expense
    }
    
    func getExpenses(budget: Budget) -> [Expense] {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "(amount > 0) AND (budget = %@)", budget)
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        var fetched: [Expense] = []
        do {
            fetched = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error fetching budgets")
        }
        return fetched
    }

    func deleteExpense(idx: Int, budget: Budget) {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "(amount > 0) AND (budget = %@)", budget)
        let viewContext = persistentContainer.viewContext
        do {
           let expenses = try viewContext.fetch(request)
           let removedItem = expenses[idx] as NSManagedObject
           viewContext.delete(removedItem)
           saveContext()

       } catch let error {
           print("Failed to delete: \(error)")
       }
    }
    
    func deleteBudget(idx: Int) {
        let request: NSFetchRequest<Budget> = Budget.fetchRequest()
//        request.predicate = NSPredicate(format: "(amount > 0)")
        let viewContext = persistentContainer.viewContext
        do {
           let budgets = try viewContext.fetch(request)
           let removedItem = budgets[idx] as NSManagedObject
           viewContext.delete(removedItem)
           try viewContext.save()

       } catch let error {
           print("Failed to delete: \(error)")
       }
    }
    
    func getBudgets() -> [Budget] {
        let request: NSFetchRequest<Budget> = Budget.fetchRequest()
        var fetchedBudgets = [Budget]()
        do {
            fetchedBudgets = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error fetch budgets")
        }
        return fetchedBudgets
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
