//
//  ViewController.swift
//  MealFinder
//
//  Created by Catherine Shing on 2/11/23.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    @IBOutlet var foodTableView: UITableView!
    @IBOutlet var textField: UITextField!
    
    var meals = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        foodTableView.dataSource = self
        foodTableView.delegate = self
        textField.delegate = self
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! RecipeTableViewCell
        let meal = meals[indexPath.row]
        let url = URL(string: meal.strMealThumb)!

        DispatchQueue.global().async {
            // Fetch Image Data
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    // Create Image and Update Image View
                    cell.mealImage?.image = UIImage(data: data)
                }
            }
        }
        cell.mealName?.text =  meal.strMeal
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        foodTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchRecipes()
        return true
    }
    
    func searchRecipes() {
        print("hiii")
        textField.resignFirstResponder()
        
        guard let text = textField.text, !text.isEmpty else {
            return
        }
        
        let query = text.replacingOccurrences(of: " ", with: "%20")        
        meals.removeAll()
    
        URLSession.shared.dataTask(with: URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=\(query)")!, completionHandler: { data, response, error in
            print("data", data)
            print("response", response)
            print("error", error)
            guard let data = data, error == nil else {
                return
            }

                // Convert
                var result: Recipes?
                do {
                    result = try JSONDecoder().decode(Recipes.self, from: data)
                    print(result)
                }
                catch {
                    print("error")
                }

                guard let finalResult = result else {
                    return
                }
            
                print("finalResult", finalResult)

                // Update our movies array
                let newMeals = finalResult.meals
                self.meals.append(contentsOf: newMeals)

                // Refresh our table
                DispatchQueue.main.async {
                    self.foodTableView.reloadData()
                }

            }).resume()
        }
}

