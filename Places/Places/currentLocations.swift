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
    
    var locationManager:CLLocationManager!
    var region: MKCoordinateRegion?
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.requestLocation()
                locationManager.requestWhenInUseAuthorization()
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
                let locValue : CLLocationCoordinate2D = locationManager.location!.coordinate
                region = MKCoordinateRegion(center: locValue, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            }
        } else {
            print("Location services are not enabled")
        }
        
//        if CLLocationManager.authorizationStatus() == .notDetermined {
//            self.locationManager.requestWhenInUseAuthorization()
//        }
        // Check for Location Services
        
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.requestLocation()
//            locationManager.requestWhenInUseAuthorization()
//            locationManager.requestAlwaysAuthorization()
//            locationManager.startUpdatingLocation()
//            let locValue : CLLocationCoordinate2D = locationManager.location!.coordinate
//            region = MKCoordinateRegion(center: locValue, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//        }
    
            
        
    }
    
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // locationManager.requestLocation()
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
   //     let locValue : CLLocationCoordinate2D = locationManager.location!.coordinate
    //   region = MKCoordinateRegion(center: locValue, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

  }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            print("User allowed us to access location")
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
      
}
}
