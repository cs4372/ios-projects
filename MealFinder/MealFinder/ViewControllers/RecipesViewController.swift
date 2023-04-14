//
//  RecipesViewController.swift
//  MealFinder
//
//  Created by Catherine Shing on 2/11/23.
//

import UIKit
import SafariServices

class RecipesViewController: UIViewController {
    @IBOutlet weak var foodTableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var emptyResultsLabel: UILabel!
    var meals = [Recipe]()
    var resultsNotFound = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodTableView.dataSource = self
        foodTableView.delegate = self
        textField.delegate = self
    }
}

extension RecipesViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
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
        if let urlObj = URL(string: url) {
            let vc = SFSafariViewController(url: urlObj)
            present(vc, animated: true)
        }
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
        
        NetworkManager.shared.searchRecipes(withQuery: query) { [weak self] recipes in
            if let recipes = recipes {
                self?.resultsNotFound = false
                print("recipes", recipes)
                self?.meals.append(contentsOf: recipes)
                DispatchQueue.main.async {
                    self?.foodTableView.reloadData()
                }
            } else {
                print("No recipes found")
                self?.resultsNotFound = true
                DispatchQueue.main.async {
                    self?.emptyResults()
                }
            }
        }
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

