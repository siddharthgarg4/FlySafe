//
//  MapViewController.swift
//  SecureTravel
//
//  Created by Siddharth on 15/09/19.
//  Copyright © 2019 Siddharth. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    
    let request = MKLocalSearch.Request()
    var matchingItems : [MKMapItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let items = ["consulate", "hospitals", "airport", "hostels", "hotels"]
        for item in items {
            //finding nearby hospitals
            request.naturalLanguageQuery = item
            request.region = mapView.region
            
            mapView.showsUserLocation = true
            
            let search = MKLocalSearch(request: request)
            
            search.start(completionHandler: {(response, error) in
                
                if let results = response {
                    
                    if let err = error {
                        print("Error occurred in search: \(err.localizedDescription)")
                    } else if results.mapItems.count == 0 {
                        print("No matches found")
                    } else {
                        print("Matches found")
                        for item in results.mapItems {
                            print("Name = \(item.name ?? "No match")")
                            print("Phone = \(item.phoneNumber ?? "No Match")")
                            
                            self.matchingItems.append(item as MKMapItem)
                            print("Matching items = \(self.matchingItems.count)")
                            
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = item.placemark.coordinate
                            annotation.title = item.name
                            self.mapView.addAnnotation(annotation)
                        }
                    }
                }
            })
            
        }
        
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(viewRegion, animated: false)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
    }
    @IBAction func backToHome(_ sender: Any) {
        let homeScreen = HomeViewController()
        homeScreen.modalPresentationStyle = .fullScreen
        self.present(homeScreen, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
    
}
