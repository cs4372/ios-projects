//
//  HotelContentViewController.swift
//  Bucket-List-Hotels
//
//  Created by Catherine Shing on 1/4/23.
//

import UIKit

class HotelContentViewController: UIViewController {
    var hotel: Hotel = Hotel()
    
    @IBOutlet var hotelContent: HotelContentCell!

    
    override func viewDidLoad() {
        // Configure header view
        hotelContent.nameLabel.text = hotel.name
        
    }

}
