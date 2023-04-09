//
//  HotelTableViewController.swift
//  Bucket-List-Hotels
//
//  Created by Catherine Shing on 1/4/23.
//

import UIKit

class HotelTableViewController: UITableViewController {
    lazy var dataSource = setupDataSource()
    
    let manager = HotelDataManager()
    private var hotels:[Hotel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        hotels = manager.fetch()
        tableView.dataSource = self
        var snapshot = NSDiffableDataSourceSnapshot<Section, Hotel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(hotels, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func setupDataSource() -> HotelDiffableDataSource {
        let cellIdentifier = "datacell"
        let dataSource = HotelDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, hotel in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HotelTableViewCell
                cell.nameLabel.text = hotel.name
                cell.imageCellView.image = UIImage(named: hotel.image)
                cell.countryLabel.text = hotel.country
                cell.setStars(Int(hotel.stars) ?? 0)
                return cell
            }
        )
        return dataSource
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let hotel = self.dataSource.itemIdentifier(for: indexPath)
            else {
                return UISwipeActionsConfiguration()
            }
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
                var snapshot = self.dataSource.snapshot()
                snapshot.deleteItems([hotel])
                self.dataSource.apply(snapshot, animatingDifferences: true)
                // Call completion handler to dismiss the action button
                completionHandler(true)
            }
            deleteAction.backgroundColor = .red
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            configuration.performsFirstActionWithFullSwipe = true
            return configuration
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHotelContent" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! HotelContentViewController
                destinationController.hotel = hotels[indexPath.row]
            }
        }
    }
}
