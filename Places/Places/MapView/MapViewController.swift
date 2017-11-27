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



class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource,UIViewControllerTransitioningDelegate {
    //var list : ListViewController?
    var locationManager:CLLocationManager!
    var region: MKCoordinateRegion?
    var menu = ViewController()
    
	let transition = CustomTransitionAnimator()

    
    
    let locationData = [
        //Walker Art Gallery
        ["name": "Walker Art Gallery",
         "image" : "pet.png",
          "description" : "It is a very cool church",
         "latitude": 37.769366,
         "longitude": -122.421464],
        //Liver Buildings
        ["name": "Liver Buildings",
         "image" : "mops.png",
         "description" : "It is a very cool church",
         "latitude": 37.774115,
         "longitude": -122.427129],
        //St George's Hall
        ["name": "St George's Hall",
         "image" : "mops.png",
         "description" : "It is a very cool church",
         "latitude": 37.788888,
         "longitude": -122.400000]
    ]
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var viewForFilter: UIView!
    
    @IBAction func currentLocation(_ sender: Any) {
        if region != nil {
            self.map.setRegion(region!, animated: true)
        }
    }
	
	@IBOutlet weak var settingsButton: UIButton!
    
	
	@IBOutlet weak var profileButton: UIButton!
	
    @IBAction func profileButtonAction(_ sender: Any) {
        let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDel.showProfile()
    }
    
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    
     var isSideMenuHidden = true

    @IBAction func showSideMenu(_ sender: Any) {
        if isSideMenuHidden {
            sideMenuConstraint.constant = -3
            UIView.animate(withDuration: 0.5, animations:
                { self.view.layoutIfNeeded()}
            
            )
        } else {
            sideMenuConstraint.constant = -160
            UIView.animate(withDuration: 0.5, animations: { self.view.layoutIfNeeded()})
        }
        isSideMenuHidden = !isSideMenuHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        filterTableView.delegate = self
        filterTableView.dataSource = self
        map.removeAnnotations(map.annotations)
        addAnnotations(coords: locationData)
        viewForFilter.setCorenerAndShadow(viewForFilter)
        
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
        // Do any additional setup after loading the view.
    }

    // radius / places in radius
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //map.removeAnnotations(map.annotations)
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
         region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        let loc = CLLocation(latitude: location.coordinate.latitude as CLLocationDegrees, longitude: location.coordinate.longitude as CLLocationDegrees)
        if self.map.annotations.count != 0 {
            let annotation = self.map.annotations[0]
            self.map.removeAnnotation(annotation)
        }
        //let radius =  UserDefaults.standard.double(forKey: "Radius")
        //let circle = MKCircle(center: location.coordinate, radius: radius)
        //self.map.add(circle)
        addRadiusCircle(location: loc)
        map.setRegion(region!, animated: true)
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        myAnnotation.title = "Current location"
        
        map.addAnnotation(myAnnotation)
        locationManager.startUpdatingLocation()
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
            locationManager!.startUpdatingLocation()
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
            locationManager!.startUpdatingLocation()
        }
    }
    
    func addAnnotations(coords: [[String : Any]]){
        //map.removeAnnotations(map.annotations)
        var annotations = [CustomAnnotation]()
        for each in locationData {
            let latitude = CLLocationDegrees(each["latitude"] as! Double)
            let longitude = CLLocationDegrees(each["longitude"] as! Double)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let name = each["name"] as! String
            let descript = each["description"] as! String
            let img = each["image"] as! String
            let annotation : CustomAnnotation = CustomAnnotation(coordinate: coordinate, title: "\(name)", subtitle: "\(descript)", enableInfoButton: true, image: resizeImage(image: UIImage(named: img)!, targetSize: CGSize(width: 40.0, height: 40.0)))
            //annotation.title = "\(name)"
            //annotation.subtitle = "\(descript)"
            annotations.append(annotation)

        }
        map.addAnnotations(annotations)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }

    
    
    
    func mapView(_ map: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.green
            circle.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
//            let circle = MKCircleRenderer(overlay: overlay)
//            circle.strokeColor = UIColor.green
//            circle.fillColor = UIColor(red: 0, green: 235, blue: 20, alpha: 0.02)
//            circle.lineWidth = 1
//
//            return circle
//
    
   
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard !(annotation is MKUserLocation) else {
            return nil
        }

        if let annotation = annotation as? CustomAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.image = #imageLiteral(resourceName: "address")
                
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.leftCalloutAccessoryView = UIImageView(image: annotation.image!)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView || control == view.detailCalloutAccessoryView || control == view.leftCalloutAccessoryView {
            //print(view.annotation?.title) // your annotation's title
            //Perform a segue here to navigate to another viewcontroller
            performSegue(withIdentifier: "detailVC", sender: view)
        }
    }
        

        

  

        /////////////////////////////////////////////////////////////////////////
        
        let nameFilterArray = [ "Bar","Cafe","Restaurant", "Bank","Night Club","Museum", "Beuty Salon","Pharmacy","Hospital","Bus Station","Gas Station","University","Police","Church","Cemetery","Park","Gym"]
        let iconFilterArray = [#imageLiteral(resourceName: "bar"),#imageLiteral(resourceName: "cafe"),#imageLiteral(resourceName: "restaurant"), #imageLiteral(resourceName: "bank"),#imageLiteral(resourceName: "nightClub") ,#imageLiteral(resourceName: "museum"),#imageLiteral(resourceName: "beutySalon"),#imageLiteral(resourceName: "pharmacy"),#imageLiteral(resourceName: "hospital"),#imageLiteral(resourceName: "busStation"),#imageLiteral(resourceName: "gasStation"),#imageLiteral(resourceName: "university"), #imageLiteral(resourceName: "police"),#imageLiteral(resourceName: "Church"),#imageLiteral(resourceName: "cemetery"),#imageLiteral(resourceName: "park"),#imageLiteral(resourceName: "gym")]
        let colorCellArray = [#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1),#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1),#colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1),#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1),#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1),#colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1),#colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1),#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1),#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1),#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1),#colorLiteral(red: 0.7255562742, green: 0.7755160531, blue: 0.3035012881, alpha: 1)]
     func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameFilterArray.count
    }
    var selectedCell = NSMutableIndexSet()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var accessory=UITableViewCellAccessoryType.none
        let filterCell = tableView.dequeueReusableCell(withIdentifier: "mapFilter", for: indexPath) as! MapFilterTableViewCell
        if selectedCell.contains(indexPath.row) {
            accessory = .checkmark
        }
        filterCell.nameFilter.text = nameFilterArray[indexPath.row]
        filterCell.iconFilter.image = iconFilterArray[indexPath.row]
        filterCell.backgroundColor = colorCellArray[indexPath.row]
        filterCell.accessoryType = accessory
        filterCell.selectionStyle = .none
        return filterCell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
 // first version
        //cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)

//second version
        cell.layer.transform = CATransform3DScale(CATransform3DIdentity, -1, 1, 1)
        UIView.animate(withDuration: 0.7) {
            cell.alpha = 1
            cell.layer.transform = CATransform3DIdentity
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var accessory = UITableViewCellAccessoryType.none
        
        if selectedCell.contains(indexPath.row) {
            selectedCell.remove(indexPath.row)
            print("cancel filter: \(nameFilterArray[indexPath.row])")
            }else{
            selectedCell.add(indexPath.row)
            accessory = .checkmark
            print("choose filter: \(nameFilterArray[indexPath.row])")
            }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = accessory
        }

    }
	
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		transition.transitionMode = .present
		transition.startingPoint = menu.menuView.center
		transition.circleColor = menu.menuView.backgroundColor! //settingsButton.backgroundColor!
		
		return transition
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		transition.transitionMode = .dismiss
		transition.startingPoint = menu.menuView.center
		transition.circleColor = menu.menuView.backgroundColor!
		
		return transition
	}

	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowSettings" {
//			UIView.animate(withDuration: 0.3, animations: {
//				self.menuView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//				
//			})
			let secondVC = segue.destination as! SettingsViewController
			secondVC.transitioningDelegate = self
			secondVC.modalPresentationStyle = .custom
		}}
    
    
    func addRadiusCircle(location: CLLocation){
        
        let radius =  UserDefaults.standard.double(forKey: "Radius")
        self.map.delegate = self
        let circle = MKCircle(center: location.coordinate, radius: radius as CLLocationDistance)
        self.map.add(circle)
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
}

