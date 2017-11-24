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


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    var locationManager:CLLocationManager!
    var region: MKCoordinateRegion?
   
    //var currentLocation = currentLocations()
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var filterTableView: UITableView!
    
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
            UIView.animate(withDuration: 0.5, animations:
                { self.view.layoutIfNeeded()}
            
            )
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
        filterTableView.delegate = self
        filterTableView.dataSource = self
        
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

    // radius / places in radius
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
         region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        let loc = CLLocation(latitude: location.coordinate.latitude as CLLocationDegrees, longitude: location.coordinate.longitude as CLLocationDegrees)
        addRadiusCircle(location: loc)
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
    
    func addRadiusCircle(location: CLLocation){
        self.map.delegate = self
        let circle = MKCircle(center: location.coordinate, radius: 200 as CLLocationDistance)
        self.map.add(circle)
    }
    
    func mapView(_ map: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //        if overlay is MKCircle {
        let circle = MKCircleRenderer(overlay: overlay)
        circle.strokeColor = UIColor.red
        circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.02)
        circle.lineWidth = 1
        return circle
        
    }
    
  
    let nameFilterArray = [ "Bar","Cafe","Restaurant", "Bank","Night Club","Museum", "Beuty Salon","Pharmacy","Hospital","Bus Station","Gas Station","University","Police","Church","Cemetery","Park","Gym"]
    let iconFilterArray = [#imageLiteral(resourceName: "rsz_bar"),#imageLiteral(resourceName: "rsz_cafe"),#imageLiteral(resourceName: "rsz_restaurant"), #imageLiteral(resourceName: "rsz_bank"),#imageLiteral(resourceName: "rsz_nightclub") ,#imageLiteral(resourceName: "rsz_museum"),#imageLiteral(resourceName: "rsz_beutysalon"),#imageLiteral(resourceName: "rsz_pharmacy"),#imageLiteral(resourceName: "rsz_hospital"),#imageLiteral(resourceName: "rsz_bus_station"),#imageLiteral(resourceName: "rsz_gasstation"),#imageLiteral(resourceName: "rsz_1university"), #imageLiteral(resourceName: "rsz_police"),#imageLiteral(resourceName: "rsz_church"),#imageLiteral(resourceName: "rsz_cemetery"),#imageLiteral(resourceName: "rsz_park"),#imageLiteral(resourceName: "rsz_gym")]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameFilterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filterCell = tableView.dequeueReusableCell(withIdentifier: "mapFilter", for: indexPath) as! MapFilterTableViewCell
        let name = nameFilterArray[indexPath.row]
       filterCell.nameFilter.setTitle(name, for: .normal)
       filterCell.iconFilter.image = iconFilterArray[indexPath.row]
        
        return filterCell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
 // first version
       // let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
       //cell.layer.transform = transform
//second version
        cell.layer.transform = CATransform3DScale(CATransform3DIdentity, -1, 1, 1)
        UIView.animate(withDuration: 0.4) {
            cell.alpha = 1
            cell.layer.transform = CATransform3DIdentity
        }
    }


}

