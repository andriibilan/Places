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


class MapViewController: UIViewController {
    var isSideMenuHidden = true
   
    var currentLocation = currentLocations()
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentLocation.determineMyCurrentLocation()
        if currentLocation.region != nil {
            self.map.setRegion(currentLocation.region!, animated: true)
        }
        map.showsUserLocation = true
        sideMenuConstraint.constant = -160
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
