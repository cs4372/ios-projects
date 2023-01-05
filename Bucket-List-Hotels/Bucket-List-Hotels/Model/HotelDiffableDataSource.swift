//
//  HotelDiffableDataSource.swift
//  Bucket-List-Hotels
//
//  Created by Catherine Shing on 1/4/23.
//

import UIKit

enum Section {
    case main
}

class HotelDiffableDataSource: UITableViewDiffableDataSource<Section, Hotel> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

