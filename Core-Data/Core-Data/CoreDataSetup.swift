//
//  CoreDataSetup.swift
//  Core-Data
//
//  Created by Catherine Shing on 1/25/23.
//

import CoreData

struct CoreDataSetup {
    let container: NSPersistentContainer = {
         let container = NSPersistentContainer(name: "Person")
         container.loadPersistentStores { (storeDescription, error) in
             if let error = error {
                 fatalError("Loading of store failed \(error)")
             }
         }

         return container
     }()
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
        
    @discardableResult
    func createPerson(name: String, age: Int) -> Person? {
        let context = container.viewContext
        let person = Person(context: context)
        person.name = name
        person.age = Int16(age)

        do {
            try context.save()
            return person
        } catch let error {
            print("Failed to create: \(error)")
        }
        return nil
    }
    
    func fetchPeople() -> [Person]? {
         let context = container.viewContext
         let fetchRequest = NSFetchRequest<Person>(entityName: "Person")

         do {
             let people = try context.fetch(fetchRequest)
             return people
         } catch let error {
             print("Failed to fetch people: \(error)")
         }
         return nil
     }
    
    func fetchPerson(withName name: String) -> Person? {
        let context = container.viewContext
          let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
          fetchRequest.fetchLimit = 1
          fetchRequest.predicate = NSPredicate(format: "name == %@", name)

          do {
              let person = try context.fetch(fetchRequest)
              return person.first
          } catch let error {
              print("Failed to fetch: \(error)")
          }

          return nil
      }
    
    func updatePerson(person: Person) {
         let context = container.viewContext
        
         do {
             try context.save()
         } catch let error {
             print("Failed to update: \(error)")
         }
     }

    func deletePerson(person: Person) {
        let context = container.viewContext
        context.delete(person)

           do {
               try context.save()
           } catch let error {
               print("Failed to delete: \(error)")
           }
        }
    
    func deleteAllData(_ entity: String) {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        }
        catch let error {
            print("Failed to delete all data: \(error)")
        }
    }
}
