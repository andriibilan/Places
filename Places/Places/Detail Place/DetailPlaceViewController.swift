//
//  DetailPlaceViewController.swift
//  Places
//
//  Created by Andrii Antoniak on 11/22/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

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
    
    
    
    //
    let testPlace = TestPlace()
    //
    
    
    @IBOutlet weak var heightConstaintForReviewTable: NSLayoutConstraint!
    
    
    //TODO: load real image when I'll have choosing place
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        testPlace.installDefaultValues()
        //
        
        
        
        //
        placeName?.text = testPlace.name
        
        placeAddress?.text = testPlace.address
        
        if let ratting = testPlace.ratting{
            let ratting = ratting.rounded(toPlaces: 1)
            placeRattingLabel?.text = String(ratting.rounded(toPlaces: 1))
        }
        placeWebsite?.text = testPlace.website
        
        placeHours?.text = testPlace.hours
        
        placePhone?.text = testPlace.phone
        //
        

        
        placeRattingView?.addSubview(Rating(x: 0.0, y: 0.0, height: Double((placeRattingView?.frame.height)!), currentRate: testPlace.ratting!))
        
        
        
            PhotoCollectionView.delegate = self
            PhotoCollectionView.dataSource = self
         
        
        
        //
       
       
            feedbackTableView.delegate = self
            feedbackTableView.dataSource = self
        
        

        
   
        
        
    }
    
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("pre-end: \(heightTable)")
        heightConstaintForReviewTable.constant = heightTable
        print("end: \(heightTable)")
    }
    
    @IBAction func openWebsite(_ sender: UIButton) {
        guard let website = testPlace.website else{
            return
        }
        let websiteURL = NSURL(string: "http://\(website)")! as URL
        UIApplication.shared.open(websiteURL, options: [:], completionHandler: nil)
    }
    
    
    
    //TODO: Check it on device
    @IBAction func openPhone(_ sender: UIButton) {
        if let phone = placePhone?.text{
       //     UIApplication.sharedApplication.openURL(NSURL(string: "telprompt://\(phone)")!)
            
            
            
       //     let phoneURL = NSURL(string: "telprompt://\(phone)")! as URL
            let phoneURL = NSURL(string: "telprompt://1234567891")! as URL
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        }
    }
    
    
    
    @IBAction func sharePlace(_ sender: UIButton) {
        let shareInfo = UIActivityViewController(activityItems: [testPlace.image[0] , "Name: \(String(describing: placeName?.text))"], applicationActivities: nil)
        self.present(shareInfo, animated: true, completion: nil)
    }
    
    
    
    
    
 
    
    

    //TODO: IF item is selected than go to PhotoPagingViewController
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: here must returning current image with current image but not today
        performSegue(withIdentifier: "DetailToPhoto", sender:  indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailToPhoto"{
            let photoVC = segue.destination as! PhotoPagingViewController
            
            for temp in testPlace.image{
                photoVC.photoArray.append(temp)
            }
            photoVC.photoArray = self.testPlace.image
            photoVC.indexPath = sender as? IndexPath
        }
    }
    
    
    
    //MARK: Collection View Data Source
    
    //function for returning number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print( testPlace.image.count)
        return testPlace.image.count
    }
    
    //function for filling my cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell
       // cell?.frame.size = feedbackTableView.estimatedRowHeight
 //       cell?.sizeToFit()
        
        if testPlace.image.count != 0{
            cell?.photoImageView?.image = testPlace.image[indexPath.row]
        }else{
            cell?.photoImageView?.image = #imageLiteral(resourceName: "noPhotoIcon")
        }
        //
        
        
        return cell!
    }
    
    ///
 
    
    //
    
    
    var heightTable :CGFloat = 0.0
    //
    
  
    
    //MARK: Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(testPlace.forReview.count)")
        return testPlace.forReview.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let review = testPlace.forReview[indexPath.row]
        
        let cell  = feedbackTableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewTableViewCell
        
        cell.labelForReview.text = review.review
        if review.isanonymous{
            cell.labelForReviewer.text = "Anonymous"
        }else{
            cell.labelForReviewer.text = review.reviewer
        }
        //TODO:RATTING
        cell.viewForRatting?.addSubview(Rating(x: 0.0, y: 0.0, height: Double((cell.viewForRatting?.frame.height)!), currentRate: testPlace.forReview[indexPath.row].reviewRatting!))
        
        
//
//
        
       
        
        
        
        
        heightTable += cell.labelForReviewer.frame.height + cell.labelForReview.frame.height
        
        
        
        
      
       
        //
        
        print("reviewer: \(cell.labelForReviewer.frame.height)")
        print("reviewer: \(cell.labelForReview.frame.height)")
        print("height: \(heightTable)")
        
        
        heightConstaintForReviewTable.constant = heightTable
        return cell
    }
    
}
