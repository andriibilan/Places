//
//  DetailPlaceViewController.swift
//  Places
//
//  Created by Andrii Antoniak on 11/22/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit
import MapKit

class DetailPlaceViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var PhotoCollectionView: UICollectionView!
    
    @IBOutlet weak var placeName: UILabel?
    
    @IBOutlet weak var placeAddress: UILabel?
    
    @IBOutlet weak var placeRattingLabel: UILabel?
    
    @IBOutlet weak var placeRattingView: UIView?
    
    @IBOutlet weak var placeWebsite: UILabel?
    
    @IBOutlet weak var placeHours: UILabel?
    
    @IBOutlet weak var placePhone: UILabel?
    
    @IBOutlet weak var feedbackTableView: UITableView!
    
    @IBOutlet weak var placeType: UILabel?
    
    @IBOutlet weak var dismissButton: UIButtonExplicit!
    
    @IBOutlet weak var placeTypeIcon: UIImageView!
    
    @IBOutlet weak var placeAddressIcon: UIImageViewExplicit!
    
    @IBOutlet weak var placeClockIcon: UIImageViewExplicit!
    
    @IBOutlet weak var placePhoneIcon: UIImageViewExplicit!
    
    @IBOutlet weak var placeWebsiteIcon: UIImageViewExplicit!
    
    @IBOutlet weak var heightConstaintForReviewTable: NSLayoutConstraint!
    
    @IBOutlet weak var heightProportionalConstrainForPhotoColelctionView: NSLayoutConstraint!
    
    @IBOutlet weak var heightEqualConstraintForCollectionView: NSLayoutConstraint!
    
    @IBOutlet weak var heightProportionalConstraintForWebsite: NSLayoutConstraint!
    
    @IBOutlet weak var heightEqualConstantForWebsite: NSLayoutConstraint!
    
    @IBOutlet weak var heightProportionalConstrainForPhone: NSLayoutConstraint!
    
    @IBOutlet weak var heightEqualConstantForPhone: NSLayoutConstraint!
    
    @IBOutlet weak var heightProportionalConstrainForClock: NSLayoutConstraint!
    
    @IBOutlet weak var heightEqualConstantForClock: NSLayoutConstraint!
    
    @IBOutlet weak var heightProportionalConstrainForAddress: NSLayoutConstraint!
    
    @IBOutlet weak var heightEqualConstrainForAddress: NSLayoutConstraint!
    
    @IBOutlet weak var heightProportionalConstrainForType: NSLayoutConstraint!
    
    @IBOutlet weak var heightEqualConstrainForType: NSLayoutConstraint!
    
    let transition = CustomTransitionAnimator()
    
    var place:Place!
    
    var mapView : MKMapView!
    
    
    
    
    //
    @IBOutlet weak var clockInfo: UIButton!
    
    @IBOutlet weak var scheduleTimeLabel: UILabel!
    
    @IBOutlet weak var heightEqualConstrainForSchedule: NSLayoutConstraint!
    
    private var isInfoOpen = false
    
    @IBAction func openCloseClockInfo(_ sender: UIButton) {
        switch isInfoOpen {
        case true :
            isInfoOpen = false
            heightEqualConstrainForSchedule.constant = 0
        case false:
            isInfoOpen = true
            heightEqualConstrainForSchedule.constant = scheduleTimeLabel.frame.width / 2
        }
    }
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissButton.layer.cornerRadius = dismissButton.bounds.size.width * 0.35
        dismissButton.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 180))
        dismissButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        if let name = place.name {
            placeName?.text = name
        }
        if let time = place.workingSchedule {
            scheduleTimeLabel.text = """
            \(time[0])
            \(time[1])
            \(time[2])
            \(time[3])
            \(time[4])
            \(time[5])
            \(time[6])
            """
        }else {
            clockInfo.isHidden = true
        }
        feedbackTableView.reloadData()
        heightConstaintForReviewTable.constant = feedbackTableView.contentSize.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.setAllData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        heightConstaintForReviewTable.constant = feedbackTableView.contentSize.height
    }
    
    @IBAction func openWebsite(_ sender: UIButton) {
        if let website = place.website {
            let websiteURL = NSURL(string: "\(website)")! as URL
            UIApplication.shared.open(websiteURL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func openPhone(_ sender: UIButton) {
        var phoneNumber = ""
        if var phone = placePhone?.text {
            while (!phone.isEmpty) {
                let char = phone.removeLast()
                if let _ = Int(String(char)) {
                    phoneNumber += String(char)
                }
            }
            let phoneURL = NSURL(string: "telprompt://\(phoneNumber)")! as URL
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func sharePlace(_ sender: UIButton) {
        let shareInfo = UIActivityViewController(activityItems: [place.photos[0], "Name: \(String(describing: placeName?.text))", "\(((placeType?.text) != nil) ? ", Type: " + (placeType?.text)! : "")", "\(((placeRattingLabel?.text) != nil) ? "Ratting: " + (placeRattingLabel?.text)! : "");"], applicationActivities: nil)
        self.present(shareInfo, animated: true, completion: nil)
    }
    
    @IBAction func dismissAction(_ sender: UIButtonExplicit) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AlertForCreatingPathBetweenTwoLocations(_ sender: UIButton) {
        let mapAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        if let subview = mapAlert.view.subviews.first, let mapAlert = subview.subviews.first {
            for innerView in mapAlert.subviews {
                innerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                innerView.layer.cornerRadius = 15.0
                innerView.clipsToBounds = true
            }
        }
        mapAlert.addAction(UIAlertAction(title: "Place Map", style: .default, handler: {(action:UIAlertAction) in
            self.drawRouteAtPlaceMap(sourse: CLLocationCoordinate2D(latitude: pressCoordinate.latitude, longitude: pressCoordinate.longitude), destination: CLLocationCoordinate2D(latitude: (self.place.location?.latitude)!, longitude: (self.place.location?.longitude)!))
        }))
        mapAlert.addAction(UIAlertAction(title: "Apple Map", style: .default, handler: {(action:UIAlertAction) in
            self.drawRouteAtAppleMap()
        }))
        mapAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        mapAlert.view.tintColor = #colorLiteral(red: 0.9211991429, green: 0.2922174931, blue: 0.431709826, alpha: 1)
        self.present(mapAlert, animated: true, completion: nil)
    }
    
    func drawRouteAtAppleMap() {
        let regionDistance : CLLocationDistance = Double(place.distance!)
        let coordinates = CLLocationCoordinate2DMake((place.location?.latitude)!, (place.location?.longitude)!)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = place?.name
        mapItem.openInMaps(launchOptions: options)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailToPhoto" {
            let photoVC = segue.destination as! PhotoPagingViewController
            photoVC.photoArray = self.place.photos
            photoVC.indexPath = sender as? IndexPath
            photoVC.transitioningDelegate = self
            photoVC.modalPresentationStyle = .custom
        }/*else if segue.identifier == "DetailToMap" {
            let MapVC = segue.destination as! MapViewController
            MapVC.map.add((sender as! MKRoute).polyline, level: .aboveRoads)
        }*/
    }
    
    func setAllData() {
        if !setData(set: place.rating, at: placeRattingView) {
            let _ = setData(set: 0, at: placeRattingView)
        }
        if !setData(set: place.types, at: placeType) {
            heightProportionalConstrainForType.isActive = false
            heightEqualConstrainForType.isActive = true
            placeTypeIcon.isHidden = true
        }
        if !setData(set: place.address, at: placeAddress) {
            heightProportionalConstrainForAddress.isActive = false
            heightEqualConstrainForAddress.isActive = true
            placeAddressIcon.isHidden = true
        }
        if !setData(set: place.isOpen, at: placeHours) {
            heightProportionalConstrainForClock.isActive = false
            heightEqualConstantForClock.isActive = true
            placeClockIcon.isHidden = true
        }
        if !setData(set: place.phoneNumber, at: placePhone) {
            heightProportionalConstrainForPhone.isActive = false
            heightEqualConstantForPhone.isActive = true
            placePhoneIcon.isHidden = true
        }
        if !setData(set: place.website, at: placeWebsite) {
            heightProportionalConstraintForWebsite.isActive = false
            heightEqualConstantForWebsite.isActive = true
            placeWebsiteIcon.isHidden = true
        }
    }
    
    //MARK: Overloading setData function
    
    func setData(set data: String?, at label: UILabel?) -> Bool {
        if data != nil && data != "" {
            label?.text = data
            return true
        }
        return false
    }
    
    func setData(set data: Double?, at view: UIView?) -> Bool {
        if let ratting = data {
            let ratting = ratting.rounded(toPlaces: 1)
            self.placeRattingLabel?.text = "★ " + String(ratting.rounded(toPlaces: 1))
            view?.addSubview(Rating(x: 0.0, y: 0.0, height: Double((self.placeRattingView?.frame.height)!), currentRate: ratting))
            return true
        }
        return false
    }
    
    func setData(set data: Bool?, at label: UILabel?) -> Bool {
        switch self.place.isOpen {
        case true?:  label?.text = NSLocalizedString("Open", comment: "")
        case false?:  label?.text = NSLocalizedString("Close", comment: "")
        default:
            return false
        }
        return true
    }
    
    func setData(set data: [PlaceType]?, at label: UILabel?) -> Bool {
        if data?.count != 0 {
            var str = ""
            for type in data! {
                str += type.printableStyle + ", "
            }
            str.removeLast()
            str.removeLast()
            label?.text = str
            self.placeTypeIcon?.image = self.place.icon
            self.placeTypeIcon?.tintColor = #colorLiteral(red: 0.9211991429, green: 0.2922174931, blue: 0.431709826, alpha: 1)
            return true
        }
        return false
    }
    
    func drawRouteAtPlaceMap(sourse: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        
        let sourseItem = MKMapItem(placemark: MKPlacemark(coordinate: sourse))
        let destItem = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourseItem
        directionRequest.destination = destItem
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {
            responce, error in
            
            guard let responce = responce else {
                if let error = error {
                    print("Something whent wrong \(error)")
                }
                return
            }
            
            let route = responce.routes[0]
            
            if let _ = self.mapView {
                self.mapView.add(route.polyline, level: .aboveRoads)
            }
            
            self.dismiss(animated: true, completion: nil)
            
        //  self.performSegue(withIdentifier: "DetailToMap", sender: route)
        })
    }
}
