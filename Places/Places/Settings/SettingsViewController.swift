//
//  SettingsTableViewController.swift
//  Places
//
//  Created by andriibilan on 11/23/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController {


	
	@IBOutlet weak var dismissButton: UIButton!{
		didSet{
			dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
			dismissButton.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 180))
		}
	}
	
	@IBAction func dismissButtonTaped(_ sender: UIButton) {
        print(UserDefaults.standard.integer(forKey: "Radius"))

       performSegue(withIdentifier: "exitFromSettingsSegue", sender: self)
        

	}

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
		
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    
   


	
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            switch identifier {
            case "showMapSettings":
                let mapSettingsVC = segue.destination 
                //mapSettingsVC.transitioningDelegate = slider
                
                //            case "showUserSettings":
//                let userSettingsVC = segue.destination as! UserSettingTableViewController
            default:
                break
            }
        }
    }
}

