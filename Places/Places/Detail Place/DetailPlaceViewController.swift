//
//  DetailPlaceViewController.swift
//  Places
//
//  Created by Andrii Antoniak on 11/22/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit
import MapKit

class DetailPlaceViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {
    
    
    
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
    
    
   
    
    
    
    
	var place:Place!

    //
    //
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
    
    
    //
    //
    
   
    
    //TODO: load real image when I'll have choosing place
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        dismissButton.layer.cornerRadius = dismissButton.bounds.size.width * 0.35
        dismissButton.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 180))
        dismissButton.backgroundColor = #colorLiteral(red: 0.8338858485, green: 0.2595152557, blue: 0.3878593445, alpha: 1)
        //
        
        //TODO: height 0 if data is null
       
        
        placeName?.text = place.name ?? "Lol"
        
   //     placeAddress?.text = place.address ?? "lol"
        
//        if let ratting = place.rating{
//            let ratting = ratting.rounded(toPlaces: 1)
//            placeRattingLabel?.text = "★ " + String(ratting.rounded(toPlaces: 1))
//            placeRattingView?.addSubview(Rating(x: 0.0, y: 0.0, height: Double((placeRattingView?.frame.height)!), currentRate: ratting))
//        }
        
  //      placePhone?.text = place.phoneNumber
       
        
        
        
        
        placeTypeIcon?.image = place.icon
        placeTypeIcon?.tintColor = #colorLiteral(red: 0.9211991429, green: 0.2922174931, blue: 0.431709826, alpha: 1)
       
//        var str = ""
//        for type in place.types{
//            str += type.rawValue + ", "
//        }
//        str.removeLast()
//        str.removeLast()
//        placeType?.text = str

        //
        
        feedbackTableView.reloadData()
        heightConstaintForReviewTable.constant = feedbackTableView.contentSize.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            //
            if self.place.website != "" && self.place.website != nil{
                self.placeWebsite?.text = self.place.website
            }else{
                self.heightProportionalConstraintForWebsite.isActive = false
                self.heightEqualConstantForWebsite.isActive = true
            }
            //
            if self.place.phoneNumber != "" && self.place.phoneNumber != nil{
                self.placePhone?.text = self.place.phoneNumber
            }else{
                self.heightProportionalConstrainForPhone.isActive = false
                self.heightEqualConstantForPhone.isActive = true
            }
            //
            switch self.place.isOpen{
            case true?:  self.placeHours?.text = "Open"
            case false?:  self.placeHours?.text = "Close"
            default:
                self.heightProportionalConstrainForClock.isActive = false
                self.heightEqualConstantForClock.isActive = true
            }
            //
            if self.place.address != "" && self.place.address != nil{
                self.placeAddress?.text = self.place.address
            }else{
                self.heightProportionalConstrainForAddress.isActive = false
                self.heightEqualConstrainForAddress.isActive = true
            }
            //
            if let ratting = self.place.rating{
                let ratting = ratting.rounded(toPlaces: 1)
                self.placeRattingLabel?.text = "★ " + String(ratting.rounded(toPlaces: 1))
                self.placeRattingView?.addSubview(Rating(x: 0.0, y: 0.0, height: Double((self.placeRattingView?.frame.height)!), currentRate: ratting))
            }else{
                let ratting = 0
                self.placeRattingLabel?.text = "★ " + String(ratting)
                self.placeRattingView?.addSubview(Rating(x: 0.0, y: 0.0, height: Double((self.placeRattingView?.frame.height)!), currentRate: Double(ratting)))
            }
            //
            if self.place.types.count != 0{
                var str = ""
                for type in self.place.types{
                    str += type.rawValue + ", "
                }
                str.removeLast()
                str.removeLast()
                self.placeType?.text = str
                //
                self.placeTypeIcon?.image = self.place.icon
                self.placeTypeIcon?.tintColor = #colorLiteral(red: 0.9211991429, green: 0.2922174931, blue: 0.431709826, alpha: 1)
            }else{
                self.heightProportionalConstrainForType.isActive = false
                self.heightEqualConstrainForType.isActive = true
            }
            //
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
    
    
    
    //TODO: Check it on device
    @IBAction func openPhone(_ sender: UIButton) {
        if let phone = placePhone?.text{
           /* for index in 0...phone.count - 1{
                if phone.re == " "{
                    phone.remove(at: index)
                }
            }*/
            let phoneURL = NSURL(string: "telprompt://\(phone)")! as URL
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        }
    }
    
    
    
    @IBAction func sharePlace(_ sender: UIButton) {
        let shareInfo = UIActivityViewController(activityItems: [place.icon ?? "" , "Name: \(String(describing: placeName?.text))", "\(((placeType?.text) != nil) ? ", Type: " + (placeType?.text)! : "")", "\(((placeRattingLabel?.text) != nil) ? "Ratting: " + (placeRattingLabel?.text)! : "");"], applicationActivities: nil)
        self.present(shareInfo, animated: true, completion: nil)
    }
    
    
    @IBAction func dismissAction(_ sender: UIButtonExplicit) {
        dismiss(animated: true, completion: nil)
    }
    

    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailToPhoto", sender:  indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailToPhoto"{
            let photoVC = segue.destination as! PhotoPagingViewController
            
            
            //TODO: REAL IMAGE
            photoVC.photoArray = self.place.photos
            photoVC.indexPath = sender as? IndexPath
        }
    }
    
    
    
    //MARK: Collection View Data Source
    
    //function for returning number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        print("photos counter: \(place.photos.count)")
        if place.photos.count == 0{
            heightProportionalConstrainForPhotoColelctionView.isActive = false
            heightEqualConstraintForCollectionView.isActive = true
        }
        return place.photos.count
    }
    
    //function for filling my cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell
        if place.photos.count != 0{
            cell?.photoImageView?.image = place.photos[indexPath.row]
        }
        cell?.layer.borderColor = #colorLiteral(red: 0.9211991429, green: 0.2922174931, blue: 0.431709826, alpha: 1)
        cell?.layer.borderWidth = 5
        return cell!
    }
    
   
    
    //MARK: Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("review count:\(place.reviews.count)")
        return place.reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let review = place.reviews[indexPath.row]
        
        let cell  = feedbackTableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewTableViewCell
        
        //
        cell.layer.cornerRadius = 15
        cell.layer.borderColor = #colorLiteral(red: 0.2275260389, green: 0.6791594625, blue: 0.5494497418, alpha: 1)
        cell.layer.borderWidth = 1.5
        //
        

        cell.labelForReview.text = review.text
        cell.labelForReview.backgroundColor? = #colorLiteral(red: 0.9211991429, green: 0.2922174931, blue: 0.431709826, alpha: 1)
        cell.labelForReview.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        cell.labelForReviewer.text = review.author
        cell.labelForReviewer.textColor = #colorLiteral(red: 0.2275260389, green: 0.6791594625, blue: 0.5494497418, alpha: 1)
        
        cell.viewForRatting?.addSubview(Rating(x: 0.0, y: 0.0, height: Double((cell.viewForRatting?.frame.height)!), currentRate: Double(review.rating!)))
        
        cell.ImageViewForIcon?.image = loadImageFromPath(path: review.profilePhotoUrl!)

        return cell
    }
    
    
    
    
    
    @IBAction func createPathBetweenTwoLocations(_ sender: UIButton) {
     //   let latitude : CLLocationDegrees = 39.048625
     //   let longitude : CLLocationDegrees = -120.981227
        
        let regionDistance : CLLocationDistance = Double(place.distance!);
       
      //  let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let coordinates = CLLocationCoordinate2DMake((place.location?.latitude)!, (place.location?.longitude)!)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = place?.name
        mapItem.openInMaps(launchOptions: options)
      
        
    }
    
    
}//end class

func loadImageFromPath(path: String) -> UIImage? {
    if let url = URL(string: path){
        if let urlContents = try? Data(contentsOf: url){
            return UIImage(data: urlContents)
        }
    }
    return nil
}
