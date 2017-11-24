//
//  TableViewController.swift
//  Places
//
//  Created by andriibilan on 11/23/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class MapSettingTableViewController: UITableViewController {
    
    
    @IBOutlet weak var mapRadius: UILabel!
    
    @IBAction func sliderRadius(_ sender: UISlider) {
        let sliderValue = lroundf(sender.value)
        mapRadius.text = "\(sliderValue) m"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
}
