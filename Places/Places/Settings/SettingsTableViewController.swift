//
//  SettingsTableViewController.swift
//  Places
//
//  Created by andriibilan on 11/23/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController{
    let slider = SliderTransition()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            switch identifier {
            case "showMapSettings":
                let mapSettingsVC = segue.destination 
                mapSettingsVC.transitioningDelegate = slider
                
                //            case "showUserSettings":
//                let userSettingsVC = segue.destination as! UserSettingTableViewController
            default:
                break
            }
        }
    }
}
