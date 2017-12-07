//
//  DetailPlaceViewController.swift
//  Places
//
//  Created by Andrii Antoniak on 11/22/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit
import MapKit

class DetailPlaceViewController: UIViewController, UICollectionViewDelegate, UITableViewDelegate {
    
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
    
    var place:Place!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissButton.layer.cornerRadius = dismissButton.bounds.size.width * 0.35
        dismissButton.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 180))
        dismissButton.backgroundColor = #colorLiteral(red: 0.8338858485, green: 0.2595152557, blue: 0.3878593445, alpha: 1)
        if let name = place.name {
            placeName?.text = name
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
    
    @IBAction func createPathBetweenTwoLocations(_ sender: UIButton) {
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
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailToPhoto", sender:  indexPath)
    }
    
    func setAllData() {
        if !setData(set: place.rating, at: placeRattingView) {
            let _ = setData(set: 0, at: placeRattingView)
        }
        if !setData(set: place.types, at: placeType) {
            heightProportionalConstrainForType.isActive = false
            heightEqualConstrainForType.isActive = true
        }
        if !setData(set: place.address, at: placeAddress) {
            heightProportionalConstrainForAddress.isActive = false
            heightEqualConstrainForAddress.isActive = true
        }
        if !setData(set: place.isOpen, at: placeHours) {
            heightProportionalConstrainForClock.isActive = false
            heightEqualConstantForClock.isActive = true
        }
        if !setData(set: place.phoneNumber, at: placePhone) {
            heightProportionalConstrainForPhone.isActive = false
            heightEqualConstantForPhone.isActive = true
        }
        if !setData(set: place.website, at: placeWebsite) {
            heightProportionalConstraintForWebsite.isActive = false
            heightEqualConstantForWebsite.isActive = true
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
        case true?:  label?.text = "Open"
        case false?:  label?.text = "Close"
        default:
            return false
        }
        return true
    }
    
    func setData(set data: [PlaceType]?, at label: UILabel?) -> Bool {
        if data?.count != 0 {
            var str = ""
            for type in data! {
                str += type.rawValue + ", "
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
}
