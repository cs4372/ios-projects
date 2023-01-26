//
//  ViewController.swift
//  Core-Data
//
//  Created by Catherine Shing on 1/25/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var coreData = CoreDataSetup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let container = coreData.container
        performCrudOperations()
    }
    
        func performCrudOperations() {
            // Create
            guard (coreData.createPerson(name: "Cat", age: 15) != nil) else { return }
            guard coreData.createPerson(name: "Dusty", age: 12) != nil else { return }

            guard let people = coreData.fetchPeople() else { return }
            guard let person = coreData.fetchPerson(withName: "Cat") else { return }
            print("Number people: \(people.count)")

            coreData.deletePerson(person: person)

            print("Number people: \(people)")
            print("Number people: \(people.count)")
        }
}

