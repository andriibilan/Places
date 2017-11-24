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

    let locationData = [
        //Walker Art Gallery
        ["name": "Walker Art Gallery",
          "description" : "It is a very cool church",
         "latitude": 37.769366,
         "longitude": -122.421464],
        //Liver Buildings
        ["name": "Liver Buildings",
         "description" : "It is a very cool church",
         "latitude": 37.774115,
         "longitude": -122.427129],
        //St George's Hall
        ["name": "St George's Hall",
         "description" : "It is a very cool church",
         "latitude": 37.788888,
         "longitude": -122.400000]
    ]
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

        addAnnotations(coords: locationData)
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
    
    func addAnnotations(coords: [[String : Any]]){
        var annotations = [MKPointAnnotation]()
        for each in locationData {
            let latitude = CLLocationDegrees(each["latitude"] as! Double)
            let longitude = CLLocationDegrees(each["longitude"] as! Double)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let name = each["name"] as! String
            let annotation : MKPointAnnotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(name)"
            annotations.append(annotation)
            
        }
        map.addAnnotations(annotations)
        
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
            circle.strokeColor = UIColor.green
            circle.fillColor = UIColor(red: 0, green: 235, blue: 20, alpha: 0.02)
            circle.lineWidth = 1
            return circle
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("viewForAnnotation \(String(describing: annotation.title))")
        if annotation is MKUserLocation {
            return nil
        }
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        if(pinView == nil) {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.leftCalloutAccessoryView = UIImageView(image: resizeImage(image: #imageLiteral(resourceName: "church"), targetSize: CGSize(width: 30.0, height: 30.0)))
            let multiLineView = UIView(frame: CGRect(x: 0, y: 0, width: 23, height: 23))
            // add all the labels you need here
            let label1 = UILabel(frame: CGRect(x: 0, y: 10, width: 10, height: 10))
            label1.text = "Some text"
            multiLineView.addSubview(label1)
            let label2 = UILabel(frame: CGRect(x: 0, y: 20, width: 10, height: 10))
            label2.text = "some text"
            pinView!.leftCalloutAccessoryView = multiLineView

            pinView!.canShowCallout = true

        }
        return pinView
    }
    
    @IBAction func addAnnotation(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            let location = sender.location(in: map)
            let coordinate = map.convert(location,toCoordinateFrom: map)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            map.addAnnotation(annotation)
        }
    }
    
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
   
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        print("regionDidChangeAnimated")
//        let annotations = self.map.annotations
//        self.map.removeAnnotations(annotations)
//        self.map.addAnnotations(annotations)
//    }
    
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

