//
//  currentLocations.swift
//  Places
//
//  Created by Victoriia Rohozhyna on 11/21/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class currentLocations: UIViewController, CLLocationManagerDelegate {
    var region: MKCoordinateRegion?
    var locationManager:CLLocationManager!
    
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 200
        if CLLocationManager.locationServicesEnabled() {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
            let locValue : CLLocationCoordinate2D = locationManager.location!.coordinate
            region = MKCoordinateRegion(center: locValue, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        //manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")

  }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}
