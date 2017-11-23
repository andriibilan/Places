//
//  MapViewController.swift
//  Places
//
//  Created by andriibilan on 11/22/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var locationManager:CLLocationManager!
    var region: MKCoordinateRegion?
   
    //var currentLocation = currentLocations()
    @IBOutlet weak var map: MKMapView!

    @IBAction func currentLocation(_ sender: Any) {
        if region != nil {
            self.map.setRegion(region!, animated: true)
        }
    }
    
    @IBOutlet weak var menuView: UIViewX!
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    
     var isSideMenuHidden = true

    @IBAction func showSideMenu(_ sender: Any) {
        if isSideMenuHidden {
            sideMenuConstraint.constant = 0
            UIView.animate(withDuration: 0.5, animations: { self.view.layoutIfNeeded()})
        } else {
            sideMenuConstraint.constant = -160
            UIView.animate(withDuration: 0.5, animations: { self.view.layoutIfNeeded()})
        }
        isSideMenuHidden = !isSideMenuHidden
    }
    
    

    @IBAction func menuTapped(_ sender: FloatingActionButton) {
        UIView.animate(withDuration: 0.3, animations: {
            if self.menuView.transform == .identity {
                self.menuView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            } else {
                self.menuView.transform = .identity
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //map.showsUserLocation = true
        
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                locationManager.startUpdatingLocation()
            } else {
                locationManager!.requestWhenInUseAuthorization()
            }
        }
        
        sideMenuConstraint.constant = -160
         menuView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        // Do any additional setup after loading the view.
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
         region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        map.setRegion(region!, animated: true)
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        myAnnotation.title = "Current location"
        map.addAnnotation(myAnnotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    
        switch status {
        case .notDetermined:
            print("NotDetermined")
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways:
            print("AuthorizedAlways")
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
            locationManager!.startUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }

    func searchPins(){
        let pins = Array<MKPointAnnotation>() // This is an empty array, so just use your array of locations or add to this.
        
        if let currentLocation = locationManager.location?.coordinate {
            
            for pin in pins {
                
                let locationMapPoint = MKMapPointForCoordinate(currentLocation)
                
                let pinMapPoint = MKMapPointForCoordinate(pin.coordinate)
                
                let distance = MKMetersBetweenMapPoints(locationMapPoint, pinMapPoint)
                
                if distance >= 0 && distance <= 200 {
                    
                    self.map.addAnnotation(pin)
                }
            }
        }
        
    }
    
    
    
//    func closeMenu(){
//         menuView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//    }
//
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MKMapView {
    
    func topCenterCoordinate() -> CLLocationCoordinate2D {
        return self.convert(CGPoint(x: self.frame.size.width / 2.0, y: 0), toCoordinateFrom: self)
    }
    
    func currentRadius() -> Double {
        let centerLocation = CLLocation(latitude: self.centerCoordinate.latitude, longitude: self.centerCoordinate.longitude)
        let topCenterCoordinate = self.topCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        return centerLocation.distance(from: topCenterLocation)
    }
    
}
