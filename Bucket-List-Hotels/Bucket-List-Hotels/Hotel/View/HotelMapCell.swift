//
//  HotelMapCell.swift
//  Bucket-List-Hotels
//
//  Created by Catherine Shing on 1/4/23.
//

import UIKit
import MapKit

class HotelMapCell: UITableViewCell {
    
    @IBOutlet weak var mapView: MKMapView!
    
    func configureMap(with address: String, hotelName: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print("Error geocoding address: \(error.localizedDescription)")
                return
            }
            guard let placemark = placemarks?.first else {
                print("No placemark found for address: \(address)")
                return
            }
            let annotation = MKPointAnnotation()
            annotation.coordinate = placemark.location!.coordinate
            annotation.title = hotelName
            self.mapView.addAnnotation(annotation)
            
            // Set the map's visible region to the coordinate of the annotation
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
            self.mapView.setRegion(region, animated: false)
        }
    }
}
