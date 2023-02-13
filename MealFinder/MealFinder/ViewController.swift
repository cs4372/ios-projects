//
//  ViewController.swift
//  MealFinder
//
//  Created by Catherine Shing on 2/11/23.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    @IBOutlet weak var foodTableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var emptyResultsLabel: UILabel!
    var meals = [Recipe]()
    var resultsNotFound = false
    
    
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
                    cell.mealImage?.image = UIImage(data: data)
                }
            }
        }
        cell.mealName?.text =  meal.strMeal
        cell.mealCategory?.text = meal.strCategory
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        foodTableView.deselectRow(at: indexPath, animated: true)
        let meal = meals[indexPath.row]
        let url = meal.strSource
        let vc = SFSafariViewController(url: URL(string: url)!)
        present(vc, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchRecipes()
        return true
    }
    
    func searchRecipes() {
        textField.resignFirstResponder()
        
        guard let text = textField.text, !text.isEmpty else {
            return
        }
        
        let query = text.replacingOccurrences(of: " ", with: "%20")        
        meals.removeAll()
        
        URLSession.shared.dataTask(with: URL(string: "https://www.themealdb.com/api/json/v1/1/search.php?s=\(query)")!, completionHandler: { data, response, error in

            guard let data = data, error == nil else {
                return
            }

            // Convert
            var result: Recipes?
            do {
                result = try JSONDecoder().decode(Recipes.self, from: data)
                self.resultsNotFound = false
                print("result", result)
            }
            catch {
                print("inside catch")
                self.resultsNotFound = true
                DispatchQueue.main.async {
                    self.emptyResults()
                }

                print("Failed to decode data")
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
    
    func emptyResults() {
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
          emptyLabel.text = "No Data"
          emptyLabel.textAlignment = NSTextAlignment.center
          self.foodTableView.backgroundView = emptyLabel
          self.foodTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.foodTableView.reloadData()
    }
}

