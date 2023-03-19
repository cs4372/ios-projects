//
//  HotelContentViewController.swift
//  Bucket-List-Hotels
//
//  Created by Catherine Shing on 1/4/23.
//

import UIKit

class HotelContentViewController: UIViewController {
    var hotel: Hotel = Hotel()
    
    @IBOutlet var headerView: HotelContentView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        headerView.nameLabel.text = hotel.name
        headerView.locationLabel.text = hotel.country
        headerView.headerImageView.image = UIImage(named: hotel.image)
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "datacell")
    }
}

extension HotelContentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HotelDescriptionCell.self), for: indexPath) as! HotelDescriptionCell
            cell.descriptionLabel.text = hotel.description
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HotelContactInfoCell.self), for: indexPath) as! HotelContactInfoCell
            cell.addressTextLabel.text = hotel.address
            cell.phoneNumberTextLabel.text = hotel.phone
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HotelMapCell.self), for: indexPath) as! HotelMapCell
            return cell
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showMap" {
//            let destinationController = segue.destination as! MapViewController
//            destinationController.hotel = hotel
//        }
//    }
}

