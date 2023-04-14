//
//  NetworkManager.swift
//  MealFinder
//
//  Created by Catherine Shing on 4/14/23.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
        
    func searchRecipes(withQuery query: String, completion: @escaping ([Recipe]?) -> Void) {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=\(query)") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(Recipes.self, from: data)
                print("result", result)
                completion(result.meals)
            } catch {
                print("Failed to decode data: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}
