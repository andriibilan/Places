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
import Firebase


var pressCoordinate = Location(latitude: 49.841856, longitude: 24.031530)
var filterArray = [PlaceType]()

protocol SlashScreenDelegate: class {
    func splashScreen()
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate, OutputInterface {
    
    let segueToAddScreen = "addPlace"
    var locationManager: CLLocationManager!
    var region: MKCoordinateRegion?
    var menu = ViewController()
    let mapDynamic = Dynamic()
    //    var menuIsOpen = false
    private let transition = CustomTransitionAnimator()
    weak var delegate: SlashScreenDelegate?
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var viewForFilter: UIView!
    
    @IBAction func currentLocation(_ sender: Any) {
        map.removeAnnotations(self.map.annotations)
        map.removeOverlays(self.map.overlays)
        locationManager.startUpdatingLocation()
        pressCoordinate = Location(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        locationManager.stopUpdatingLocation()
        updateData()
        
    }
    private var googlePlacesManager: GooglePlacesManager!
    public var places:[Place] = []
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var compassButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var compassButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    var isSideMenuHidden = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = loadVC.customActivityIndicatory(self.view, startAnimate: true)
        mapDynamic.dynamicFilter(button: filterButton, parView: view)
        changeMapType()
        
        filterTableView.delegate = self
        filterTableView.dataSource = self
        
        locationManagerConfigurate()
        
        googlePlacesManager = GooglePlacesManager(
            apiKey: AppDelegate.apiKey,
            radius: UserDefaults.standard.integer(forKey: "Radius"),
            currentLocation: pressCoordinate,
            filters: MapViewController.checkFilter(filter: filterArray),
            completion: { (foundedPlaces, errorMessage) in
                if errorMessage != nil {
                    print("\t\(errorMessage!)")
                    self.showAlert(message: "Cannot load all places! Try it tomorrow ;)")
                    
                    DispatchQueue.main.sync {
                        self.locationManagerConfigurate()
                        _ = loadVC.customActivityIndicatory(self.view, startAnimate: false)
                    }
                }
                
                if let foundedPlaces = foundedPlaces {
                    self.places = foundedPlaces
                    DispatchQueue.main.sync {
                        self.locationManagerConfigurate()
                        self.updateData()
                    }
                }
        })
        
        viewForFilter.setCorenerAndShadow(viewForFilter)
        if UserDefaults.standard.integer(forKey: "Radius") == 0 {
            UserDefaults.standard.set(200, forKey: "Radius")
        }
        sideMenuConstraint.constant = -160
        // Do any additional setup after loading the view.
        
    }
    
    
    func changeMapType() {
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
    
    func locationManagerConfigurate() {
        
        if (CLLocationManager.locationServicesEnabled()) {
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
    
    
    func updateData() {

        _ = loadVC.customActivityIndicatory(self.view, startAnimate: true)

        let center = CLLocationCoordinate2D(latitude: pressCoordinate.latitude, longitude: pressCoordinate.longitude)
        
        googlePlacesManager = GooglePlacesManager(
            apiKey: AppDelegate.apiKey,
            radius: UserDefaults.standard.integer(forKey: "Radius"),
            currentLocation: pressCoordinate,
            filters: MapViewController.checkFilter(filter: filterArray),
            completion: { (foundedPlaces, errorMessage) in
                if errorMessage != nil {
                    print("\t\(errorMessage!)")
                    self.showAlert(message: "Cannot load all places! Try it tomorrow ;)")
                    
                    DispatchQueue.main.sync {

                        _ = loadVC.customActivityIndicatory(self.view, startAnimate: false)

                        self.addCurrentLocation(coords: center)
                    }
                }
                if let foundedPlaces = foundedPlaces {
                    self.places = foundedPlaces
                    DispatchQueue.main.sync {
                        self.addAnnotations(coords: self.places)
                        self.addCurrentLocation(coords: center)
                        loadVC.customActivityIndicatory(self.view, startAnimate: false)
                        self.delegate?.splashScreen()

                    }
                }
        })
        changeMapType()
//        self.delegate?.splashScreen()
    }
    
    
    @IBAction func showSideMenu(_ sender: UIButton) {
        if isSideMenuHidden {
            sideMenuConstraint.constant = 0
            UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
                if sender.transform == .identity {
                    sender.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 180))
                    sender.backgroundColor = #colorLiteral(red: 0.2274509804, green: 0.6784313725, blue: 0.5490196078, alpha: 1)
                    self.view.layoutIfNeeded()
                }}
                , completion: nil)
        } else {
            sideMenuConstraint.constant = -160
            UIView.animate(withDuration: 0.3,animations: {
                sender.transform = .identity
                sender.backgroundColor = #colorLiteral(red: 0.2274509804, green: 0.6784313725, blue: 0.5490196078, alpha: 1)
                self.view.layoutIfNeeded()
            }, completion: nil)
            updateData()
        }
        isSideMenuHidden = !isSideMenuHidden
    }
    
    // MARK: - Long Press Action
    
    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
        
        locationManager.stopUpdatingLocation()
        let pressPoint = sender.location(in: map)
        let location = map.convert(pressPoint, toCoordinateFrom: map)
        let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let subview = actionSheet.view.subviews.first, let actionSheet = subview.subviews.first {
            for innerView in actionSheet.subviews {
                innerView.backgroundColor = #colorLiteral(red: 0.9201840758, green: 0.2923389375, blue: 0.4312838316, alpha: 1)
                innerView.layer.cornerRadius = 15.0
                innerView.clipsToBounds = true
            }
        }
        
        actionSheet.addAction(UIAlertAction.init(title: NSLocalizedString("Add new place", comment: ""),
                                                 style: UIAlertActionStyle.default,
                                                 handler: { (action) in
                                                    pressCoordinate = Location(latitude: location.latitude,
                                                                               longitude: location.longitude )
                                                    if Auth.auth().currentUser != nil {
                                                        self.performSegue(withIdentifier: self.segueToAddScreen,
                                                                          sender: pressCoordinate)
                                                    } else {
                                                        self.performSegue(withIdentifier: "toLogin", sender: nil)
                                                    }
        }))
        
        actionSheet.addAction(UIAlertAction.init(title: NSLocalizedString("Show selected place", comment: ""),
                                                 style: UIAlertActionStyle.default,
                                                 handler: { (action) in
                                                    self.map.removeAnnotations(self.map.annotations)
                                                    self.map.removeOverlays(self.map.overlays)
                                                    
                                                    let annotation = MKPointAnnotation()
                                                    annotation.coordinate = location
                                                    annotation.title = NSLocalizedString("Selected place", comment: "")
                                                    annotation.subtitle = NSLocalizedString("Add another place", comment: "")
                                                    self.map.addAnnotation(annotation)
                                                    
                                                    let loc = CLLocation(latitude: location.latitude as CLLocationDegrees,
                                                                         longitude: location.longitude as CLLocationDegrees)
                                                    pressCoordinate = Location(latitude: location.latitude,
                                                                               longitude: location.longitude )
                                                    
                                                    
                                                    self.googlePlacesManager = GooglePlacesManager(apiKey: AppDelegate.apiKey, radius: UserDefaults.standard.integer(forKey: "Radius"), currentLocation: pressCoordinate , filters: MapViewController.checkFilter(filter: filterArray), completion: { (foundedPlaces, errorMessage) in
                                                        
                                                        if errorMessage != nil {
                                                            print("\t\(errorMessage!)")
                                                            self.showAlert(message: "Cannot load all places! Try it tomorrow ;)")
                                                            
                                                            _ = loadVC.customActivityIndicatory(self.view, startAnimate: false)
                                                        }
                                                        
                                                        if let foundedPlaces = foundedPlaces {
                                                            self.places = foundedPlaces
                                                            DispatchQueue.main.sync {
                                                                self.updateData()
                                                            }
                                                        }
                                                    })
                                                    
                                                    self.addRadiusCircle(location: loc)
        }))
        
        actionSheet.view.tintColor = #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1)
        actionSheet.addAction(UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.cancel, handler: { (action) in
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations.last! as CLLocation
        pressCoordinate = Location(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
        let center = CLLocationCoordinate2D(latitude: pressCoordinate.latitude, longitude: pressCoordinate.longitude)
        
        if map.annotations.count != 0 {
            let annotation = self.map.annotations[0]
            map.removeAnnotation(annotation)
        }
        addRadiusCircle(location: loc)
        addCurrentLocation(coords: center)
        addAnnotations(coords: places)
        locationManager.stopUpdatingLocation()
    }
    
    func addCurrentLocation(coords: CLLocationCoordinate2D) {
        map.removeAnnotations(map.annotations)
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = coords
        
        let center2D = CLLocationCoordinate2D(latitude: pressCoordinate.latitude, longitude: pressCoordinate.longitude)
        region = MKCoordinateRegion(center: center2D, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        myAnnotation.title = "Current location"
        map.setRegion(region!, animated: true)
        map.addAnnotation(myAnnotation)
        addAnnotations(coords: places)
        
        let center = CLLocation(latitude: pressCoordinate.latitude, longitude: pressCoordinate.longitude)
        addRadiusCircle(location: center)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let center2D = CLLocationCoordinate2D(latitude: pressCoordinate.latitude, longitude: pressCoordinate.longitude)
        
        region = MKCoordinateRegion(center: center2D, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        switch status {
        case .notDetermined:
            map.setRegion(region!, animated: true)
            print("NotDetermined")
        case .restricted:
            map.setRegion(region!, animated: true)
            print("Restricted")
        case .denied:
            map.setRegion(region!, animated: true)
            print("Denied")
        case .authorizedAlways:
            print("AuthorizedAlways")
            locationManager!.startUpdatingLocation()
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
            locationManager!.startUpdatingLocation()
        }
    }
    
    func addAnnotations(coords: [Place]) {
        var annotations = [CustomAnnotation]()
        
        for each in coords {
            let annotation : CustomAnnotation = CustomAnnotation(place: each)
            annotations.append(annotation as CustomAnnotation)
        }
        
        map.addAnnotations(annotations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    func mapView(_ map: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            
            circle.strokeColor = #colorLiteral(red: 0.1254901961, green: 0.6980392157, blue: 0.6666666667, alpha: 1)
            circle.fillColor = UIColor(red: 0, green: 235, blue: 20, alpha: 0.07)
            circle.lineWidth = 1
            
            return circle
        }
        
        if overlay.isKind(of: MKPolyline.self) {
            let polyLine = overlay
            let polyLineRenderer = MKPolylineRenderer(overlay: polyLine)
            polyLineRenderer.strokeColor = #colorLiteral(red: 0.9211991429, green: 0.2922174931, blue: 0.431709826, alpha: 1)
            polyLineRenderer.lineWidth = 2.0
            return polyLineRenderer
        }
        
        return MKPolylineRenderer()
        
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            if let annotation = annotation as? CustomAnnotation {
                let identifier = "pin"
                var view: MKPinAnnotationView
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.leftCalloutAccessoryView = UIImageView(image: annotation.image!)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
                view.pinTintColor = #colorLiteral(red: 0.9201840758, green: 0.2923389375, blue: 0.4312838316, alpha: 1)
                return view
            }
            let identifier = "pin"
            var view: MKPinAnnotationView
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.pinTintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            view.canShowCallout = true
            return view
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView || control == view.detailCalloutAccessoryView || control == view.leftCalloutAccessoryView {
            //Perform a segue here to navigate to another viewcontroller
            let g = view.annotation as! CustomAnnotation
            
            
            if let place = g.place {
                googlePlacesManager.getPhotos(ofPlace: place){ filledPlace, errorMessage in
                    DispatchQueue.main.async {
                        print(errorMessage ?? "")
                        self.performSegue(withIdentifier: "detailVC", sender: filledPlace)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailVC" {
            let d = segue.destination as? DetailPlaceViewController
            d?.place = sender as! Place
            d?.mapView = map
            d?.transitioningDelegate = self
            d?.modalPresentationStyle = .custom
        }
        if segue.identifier == segueToAddScreen {
            let addScreen = segue.destination as? AddNewPlaceController
            addScreen?.newLocation = pressCoordinate
            addScreen?.transitioningDelegate = self
            addScreen?.modalPresentationStyle = .custom
        }
    }
    
    func colorForIndex(index: Int) -> UIColor {
        let nameCount = nameFilterArray.count - 1
        let val = (CGFloat(index) / CGFloat(nameCount)) * 0.9
        
        return UIColor(red: val, green: 1.0, blue: 0.8, alpha: 0.7)
    }
    
    /////////////////////////////////////////////////////////////////////////
    
    
    var nameFilterArray = [ NSLocalizedString("Bar", comment: ""),
                            NSLocalizedString("Cafe", comment: ""),
                            NSLocalizedString("Restaurant", comment: ""),
                            NSLocalizedString("Bank", comment: ""),
                            NSLocalizedString("Night Club", comment: ""),
                            NSLocalizedString("Museum", comment: ""),
                            NSLocalizedString("Beauty Salon", comment: ""),
                            NSLocalizedString("Pharmacy", comment: ""),
                            NSLocalizedString("Hospital", comment: ""),
                            NSLocalizedString("Bus Station", comment: ""),
                            NSLocalizedString("Gas Station", comment: ""),
                            NSLocalizedString("University", comment: ""),
                            NSLocalizedString("Police", comment: ""),
                            NSLocalizedString("Church", comment: ""),
                            NSLocalizedString("Cemetery", comment: ""),
                            NSLocalizedString("Park", comment: ""),
                            NSLocalizedString("Gym", comment: "")]
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
        filterCell.backgroundColor = colorForIndex(index: indexPath.row)
        filterCell.accessoryType = accessory
        filterCell.selectionStyle = .none
        
        return filterCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= 12 || indexPath.row <= 4 {
            cell.alpha = 0
            cell.layer.transform = CATransform3DScale(CATransform3DIdentity, -1, 1, 1)
            UIView.animate(withDuration: 0.7) {
                cell.alpha = 1
                cell.layer.transform = CATransform3DIdentity
            }
        }
    }
    
    static func checkFilter(filter: [PlaceType]) -> [PlaceType] {
        if filter.isEmpty {
            return PlaceType.all
        } else {
            return filter
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var accessory = UITableViewCellAccessoryType.none
        
        if selectedCell.contains(indexPath.row) {
            selectedCell.remove(indexPath.row)
            var num = 0
            for i in filterArray {
                if i.rawValue == GooglePlacesManager.makeConforming(type: nameFilterArray[indexPath.row]) {
                    filterArray.remove(at: num)
                }
                num += 1
            }
        } else {
            selectedCell.add(indexPath.row)
            accessory = .checkmark
            filterArray.append(PlaceType(rawValue: GooglePlacesManager.makeConforming(type: nameFilterArray[indexPath.row]))!)
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
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        switch presenting {
        case is DetailPlaceViewController:
            transition.transitionMode = .present
            transition.startingPoint = CGPoint(x: view.bounds.midX, y: view.bounds.height - (view.bounds.height * 0.1 / 2))
            transition.circleColor = UIColor.white
        case is AddNewPlaceController:
            transition.transitionMode = .present
            transition.startingPoint = CGPoint(x: view.bounds.midX, y: view.bounds.maxY)
            transition.circleColor = UIColor(red: 235.0/255.0, green: 75.0/255.0, blue: 110.0/255.0, alpha: 1.0)
        default:
            break
        }
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        switch dismissed {
        case is DetailPlaceViewController:
            transition.transitionMode = .dismiss
            transition.startingPoint = CGPoint(x: view.bounds.midX, y: view.bounds.height - (view.bounds.height * 0.1 / 2))
            transition.circleColor = UIColor.white
        case is AddNewPlaceController:
            transition.transitionMode = .dismiss
            transition.startingPoint = CGPoint(x: view.bounds.midX, y: view.bounds.maxY)
            transition.circleColor = UIColor(red: 235.0/255.0, green: 75.0/255.0, blue: 110.0/255.0, alpha: 1.0)
        default:
            break
        }
        return transition
    }
    
}





