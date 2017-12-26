//
//  CheckIfUserLogIn.swift
//  Places
//
//  Created by andriibilan on 12/12/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit
import Firebase

extension SettingTableViewController {
    
    func checkIfUserLogIn() -> CGFloat {
        guard Auth.auth().currentUser != nil else {
            return 0.0001
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = UIColor.white
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            guard Auth.auth().currentUser != nil else {
                return ""
            }
            return NSLocalizedString("User Settings", comment: "")
        } else {
            return NSLocalizedString("Map Settings", comment: "")
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return checkIfUserLogIn()
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return checkIfUserLogIn()
        } else {
            return UITableViewAutomaticDimension
        }
    } 
}
