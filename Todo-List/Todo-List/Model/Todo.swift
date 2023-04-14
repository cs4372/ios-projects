//
//  Todo.swift
//  Todo-List
//
//  Created by Catherine Shing on 4/13/23.
//

import Foundation

struct Todo: Codable {
    var id: UUID
    var title: String
    
    init(title: String) {
         self.id = UUID()
         self.title = title
     }
}
