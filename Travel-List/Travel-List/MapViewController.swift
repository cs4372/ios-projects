//
//  MapViewController.swift
//  Travel-List
//
//  Created by Catherine Shing on 2/19/23.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        let longPressGestureRec = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation(press:)))
        longPressGestureRec.minimumPressDuration = 1.0
        longPressGestureRec.delegate = self
        mapView.addGestureRecognizer(longPressGestureRec)
    }
    
    @objc func addAnnotation(press: UILongPressGestureRecognizer) {
        if press.state == .began {
            let location = press.location(in: mapView)
            let coordinates = mapView.convert(location, toCoordinateFrom: mapView)
            let latitude = coordinates.latitude
            let longitude = coordinates.longitude
            let pinnedLocation = CLLocation(latitude: latitude, longitude: longitude)

            CLGeocoder().reverseGeocodeLocation(pinnedLocation) { (placemarks, error) in
                var result = ""
                if let error = error {
                    print("Unable to Reverse Geocode Location (\(error))")
//                    self.addressContent.text = "Unable to Find Address for Location"
                } else {
                    if let placemarks = placemarks, let placemark = placemarks.first {
                        if let name = placemark.name {
                            result+=name
                        }

                        if let locality = placemark.locality {
                            result+=", \(locality)"
                        }
                        if let administrativeArea = placemark.administrativeArea {
                            result+=", \(administrativeArea)"
                        }
                        if let postalCode = placemark.postalCode {
                            result+=", \(postalCode)"
                        }
                        print("result", result)
                        let placesObj = UserDefaults.standard.array(forKey: "places")
                        var places: [String]
                        
                        if let placesList = placesObj as? [String] {
                            places = placesList
                            places.append(result)
                        } else{
                            places = [result]
                        }
                        UserDefaults.standard.set(places, forKey: "places")
                    }
                }
            }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            
            annotation.title = "pinned Location"
            mapView.addAnnotation(annotation)
        }
    }

}
