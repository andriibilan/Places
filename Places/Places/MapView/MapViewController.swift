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



class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, OutputInterface {
    func updateData() {
        locationManagerConfigurate()
        
    }
    
    //var list : ListViewController?
    var locationManager:CLLocationManager!
    var region: MKCoordinateRegion?
    var menu = ViewController()
    
    let locationData = [
        //Walker Art Gallery
        ["name": "Walker Art Gallery",
         "image" : "pet.png",
         "description" : true,
         "latitude": 37.769366,
         "longitude": -122.421464],
        //Liver Buildings
        ["name": "Liver Buildings",
         "image" : "mops.png",
         "description" : false,
         "latitude": 37.774115,
         "longitude": -122.427129],
        //St George's Hall
        ["name": "St George's Hall",
         "image" : "mops.png",
         "description" : false,
         "latitude": 37.788888,
         "longitude": -122.400000]
    ]
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var viewForFilter: UIView!
    
    @IBAction func currentLocation(_ sender: Any) {
        
        if region != nil {
            locationManagerConfigurate()
//            self.map.setRegion(region!, animated: true)
//            locationManager.startUpdatingLocation()
        }
    }
    private var googlePlacesManager: GooglePlacesManager!
    public var places:[Place] = []
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
    // long press action
    
    
    
    
    
    
   @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
    
    let annotation = MKPointAnnotation()
    let pressPoint = sender.location(in: map)
    let pressCoordinate = map.convert(pressPoint, toCoordinateFrom: map)
    annotation.coordinate = pressCoordinate
    annotation.title = "Selected place"
    annotation.subtitle = "Add another place"
    map.addAnnotation(annotation)
    
    let loc = CLLocation(latitude: pressCoordinate.latitude as CLLocationDegrees, longitude: pressCoordinate.longitude as CLLocationDegrees)
    addRadiusCircle(location: loc)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeMapType()
    
        
        filterTableView.delegate = self
        filterTableView.dataSource = self
        
      
        
        locationManagerConfigurate()

        viewForFilter.setCorenerAndShadow(viewForFilter)

        if UserDefaults.standard.integer(forKey: "Radius") == 0 {
            UserDefaults.standard.set(200, forKey: "Radius")
        }
        googlePlacesManager = GooglePlacesManager(apiKey: "AIzaSyCOrfXohc5LOn-J6aZQHqXc0nmsYEhAxQQ", radius: UserDefaults.standard.integer(forKey: "Radius"), currentLocation: Location.currentLocation, filters: PlaceType.all, completion: { (foundedPlaces) in
            if let foundedPlaces = foundedPlaces {
                self.places = foundedPlaces
                
                DispatchQueue.main.sync {
                    self.updateData()
                }
            }
        }
        )

        sideMenuConstraint.constant = -160
        // Do any additional setup after loading the view.
    }
    
    
    
    func locationManagerConfigurate(){

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
        
    }
    
    
    
    
    // radius / places in radius
    func changeMapType(){
        map.delegate = self
        map.showsPointsOfInterest = false
        map.showsCompass = false
        map.showsBuildings = false
        map.showsTraffic = false
        map.removeAnnotations(map.annotations)
        map.removeOverlays(map.overlays)
        
        let type = UserDefaults.standard.integer(forKey: "mapType")
        switch type {
        case 1:
            map.mapType = .standard
        case 2:
            map.mapType = .hybridFlyover
        default:
            map.mapType = .standard
            break
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //map.removeAnnotations(map.annotations)
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        let loc = CLLocation(latitude: location.coordinate.latitude as CLLocationDegrees, longitude: location.coordinate.longitude as CLLocationDegrees)
        
        if map.annotations.count != 0 {
            let annotation = self.map.annotations[0]
            map.removeAnnotation(annotation)
            
        }
//        let radius =  UserDefaults.standard.integer(forKey: "Radius")
     
        addRadiusCircle(location: loc)
        let coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        addCurrentLocation(coords: coordinate)
        //locationManager.startUpdatingLocation()
        
    }
    
    func addCurrentLocation(coords: CLLocationCoordinate2D){
        map.removeAnnotations(map.annotations)
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = coords
        myAnnotation.title = "Current location"
        map.setRegion(region!, animated: true)
        map.addAnnotation(myAnnotation)
        addAnnotations(coords: places)
        //addAnnotations(coords: locationData)
        
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
    
    func addAnnotations(coords: [Place]){
        //map.removeAnnotations(map.annotations)
        var img = UIImage()
        var annotations = [CustomAnnotation]()
        for each in coords {
            let coordinate = CLLocationCoordinate2D(latitude: (each.location?.latitude)!, longitude: (each.location?.longitude)!)
            let name = each.name
            var descript = Bool()
            if each.icon != nil {
                img = each.icon!
            } else {
                img = #imageLiteral(resourceName: "mops")
            }
            if each.isOpen != nil {
                descript = each.isOpen!
            } else {
                descript = false
            }
            let annotation : CustomAnnotation = CustomAnnotation(coordinate: coordinate, title: name!, isOpen: descript, enableInfoButton: true, image: img.resizedImage(withBounds: CGSize(width: 40.0, height: 40.0)))
            
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
            circle.strokeColor = #colorLiteral(red: 0.1254901961, green: 0.6980392157, blue: 0.6666666667, alpha: 1)
            circle.fillColor = UIColor(red: 0, green: 235, blue: 20, alpha: 0.07)
            circle.lineWidth = 1
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.image = UIImage(named: "address.png")
            return view
        } else {
            
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
                    view.canShowCallout = true
                    view.image = UIImage(named: "address.png")
                    
                    view.calloutOffset = CGPoint(x: -5, y: 5)
                    view.leftCalloutAccessoryView = UIImageView(image: annotation.image!)
                    view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
                    
                }
                
                
                return view
            }
            return nil
        }
        
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView || control == view.detailCalloutAccessoryView || control == view.leftCalloutAccessoryView {
            
            //Perform a segue here to navigate to another viewcontroller
            performSegue(withIdentifier: "detailVC", sender: view)
        }
    }

        

        

    func colorForIndex(index: Int) -> UIColor {
        let nameCount = nameFilterArray.count - 1
        let val = (CGFloat(index) / CGFloat(nameCount)) * 0.9
        print(val)
        return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
    }

        /////////////////////////////////////////////////////////////////////////
        
        let nameFilterArray = [ "Bar","Cafe","Restaurant", "Bank","Night Club","Museum", "Beuty Salon","Pharmacy","Hospital","Bus Station","Gas Station","University","Police","Church","Cemetery","Park","Gym"]
        let iconFilterArray = [#imageLiteral(resourceName: "bar"),#imageLiteral(resourceName: "cafe"),#imageLiteral(resourceName: "restaurant"), #imageLiteral(resourceName: "bank"),#imageLiteral(resourceName: "nightClub") ,#imageLiteral(resourceName: "museum"),#imageLiteral(resourceName: "beutySalon"),#imageLiteral(resourceName: "pharmacy"),#imageLiteral(resourceName: "hospital"),#imageLiteral(resourceName: "busStation"),#imageLiteral(resourceName: "gasStation"),#imageLiteral(resourceName: "university"), #imageLiteral(resourceName: "police"),#imageLiteral(resourceName: "church"),#imageLiteral(resourceName: "cemetery"),#imageLiteral(resourceName: "park"),#imageLiteral(resourceName: "gym")]


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
        //filterCell.backgroundColor = colorCellArray[indexPath.row]
        filterCell.backgroundColor = colorForIndex(index: indexPath.row)
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
    
    
    
    
    
    
    func addRadiusCircle(location: CLLocation){

            for overlay in self.map.overlays {
                self.map.remove(overlay)
            }
        let radius =  UserDefaults.standard.double(forKey: "Radius")
        self.map.delegate = self
        let circle = MKCircle(center: location.coordinate, radius: radius as CLLocationDistance)
        self.map.add(circle)
    }
    
    
}



