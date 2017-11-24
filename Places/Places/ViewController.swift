//
//  ViewController.swift
//  Places
//
//  Created by andriibilan on 11/22/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var listView: UIView!
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.isHidden = false
            listView.isHidden = true
        case 1:
            mapView.isHidden = true
            listView.isHidden = false
        default:
            break
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
      listView.isHidden = true
            self.navigationController?.isNavigationBarHidden = true
    
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
}

