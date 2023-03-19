//
//  HotelDataManager.swift
//  Bucket-List-Hotels
//
//  Created by Catherine Shing on 3/19/23.
//

import Foundation

class HotelDataManager {
    
    private var items:[Hotel] = []
    
    func fetch() -> [Hotel] {

         if let file = Bundle.main.url(forResource: "Hotels", withExtension: "json") {
              do {
                  let data = try Data(contentsOf: file)
                  let hotels = try JSONDecoder().decode([Hotel].self, from: data)
                  items = hotels
              }
              catch {
                   print("there was an error \(error)")
              }
         }
        return items
    }
}
