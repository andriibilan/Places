//
//  TableViewController.swift
//  Places
//
//  Created by andriibilan on 11/23/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class MapSettingTableViewController: UITableViewController {
    let defaultsRadius = UserDefaults.standard
    
    @IBOutlet weak var mapRadius: UILabel!
    @IBOutlet weak var sliderValue: UISlider!
    
    @IBAction func sliderRadius(_ sender: UISlider) {
        let slider = lroundf(sender.value)
        mapRadius.text = "\(slider) m"
        defaultsRadius.set(slider, forKey: "Radius")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sliderValue.setValue(Float(defaultsRadius.integer(forKey: "Radius")) ,animated: true)
        mapRadius.text = String(defaultsRadius.integer(forKey: "Radius"))
        
    }
    
}
