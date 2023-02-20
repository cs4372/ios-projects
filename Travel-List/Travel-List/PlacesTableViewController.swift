//
//  PlacesTableViewController.swift
//  Travel-List
//
//  Created by Catherine Shing on 2/19/23.
//

import UIKit

class PlacesTableViewController: UITableViewController {
    var places = [String]()
    
    @IBOutlet var placesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let placesObj = UserDefaults.standard.array(forKey: "places")
        if let placesList = placesObj as? [String] {
            places = placesList
        }
        UserDefaults.standard.set(places, forKey: "places")
        placesTableView.reloadData()
    }
    
    internal override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    internal override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.textLabel?.text = places[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            places.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            UserDefaults.standard.set(places, forKey: "places")
            placesTableView.reloadData()
        }
    }
}
