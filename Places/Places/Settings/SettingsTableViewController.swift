//
//  SettingsTableViewController.swift
//  Places
//
//  Created by andriibilan on 11/23/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
	
	
	
	@IBOutlet weak var tableview: UITableView!
	
	@IBOutlet weak var dismissButton: UIButton!{
		didSet{
			dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
			dismissButton.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 180))
		}
	}
	
	@IBAction func dismissButtonTaped(_ sender: UIButton) {
			self.dismiss(animated: true, completion: nil)
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if indexPath.row == 0 {
			 return tableView.dequeueReusableCell(withIdentifier: "mapcell", for: indexPath)
		} else {
			return tableView.dequeueReusableCell(withIdentifier: "usercell", for: indexPath)
		}
		
		return UITableViewCell()
	}
	
	
	
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
		
		tableview.dataSource = self
		tableview.delegate = self 
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