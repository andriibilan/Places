//
//  TableViewController.swift
//  Places
//
//  Created by andriibilan on 11/23/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit
import Firebase
class SettingTableViewController: UITableViewController {
    let defaults = UserDefaults.standard
    
    
    @IBOutlet weak var distanceSegment: UISegmentedControl!
    @IBOutlet weak var searchRadius: UILabel!
    @IBOutlet weak var sliderValue: UISlider!
    
    @IBAction func sliderRadius(_ sender: UISlider) {
        let isDistanceAreKms = defaults.bool(forKey: "distanceIskm")
        let slider = lroundf(sender.value)
        defaults.set(slider, forKey: "Radius")
        if isDistanceAreKms == true {
            valueForMetres()
        } else {
           valueForMiles()
        }
    }
    
    @IBAction func changeDistance(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            defaults.set(true, forKey: "distanceIskm")
            valueForMetres()
        case 1:
            defaults.set(false, forKey: "distanceIskm")
            valueForMiles()
        default:
            break
        }
    }
    
    func valueForMetres() {
        let radiusValue = defaults.integer(forKey: "Radius")
        if radiusValue < 1000 {
            searchRadius.text = "Search Radius: \(radiusValue ) m"
        } else {
            searchRadius.text = "Search Radius: \( (Double(radiusValue).kilometr).rounded(toPlaces: 2) ) km"
        }
    }
    
    func valueForMiles() {
        searchRadius.text = "Search Radius: \(String((defaults.double(forKey: "Radius").miles).rounded(toPlaces: 2))) mi"
    }
    
    func updateSliderValue (distanceIsKms: Bool) {
        sliderValue.setValue(Float(defaults.integer(forKey: "Radius")) ,animated: true)
        if distanceIsKms == true {
            distanceSegment.selectedSegmentIndex = 0
            valueForMetres()
        } else {
            distanceSegment.selectedSegmentIndex = 1
           valueForMiles()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       updateSliderValue(distanceIsKms: UserDefaults.standard.bool(forKey: "distanceIskm"))
        print(Float(defaults.double(forKey: "Radius")))
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = UIColor.black
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            guard Auth.auth().currentUser != nil else {
                return ""
            }
                return "User Settings"
        } else {
            return "Map Settings"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0 :
                print("touch 1 row")
                changeEmail()
            case 1:
                print("touch 2 row")
                changePassword()
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 1:
                changeMapType()
            default:
                break
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            guard Auth.auth().currentUser != nil else {
                return 0.0001
            }
            return UITableViewAutomaticDimension
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            guard Auth.auth().currentUser != nil else {
                return 0.0001
            }
            return UITableViewAutomaticDimension
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            guard Auth.auth().currentUser != nil else {
                return 0.0001
            }
            return UITableViewAutomaticDimension
        } else {
            return UITableViewAutomaticDimension
            
        }
    }
    
    func changeEmail() {
        let emailAlertController = UIAlertController(title: "e-mail", message: "Please write new e-mail", preferredStyle: .alert)
        changeAlertProperties(alertController: emailAlertController)
        emailAlertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (alert: UIAlertAction) in
            if self.ValidatorForEmail(isEmail: emailAlertController.textFields![0].text!) {
                
                print("All is okay. email is good")
                self.changeIsGood()
                
                
            } else {
                print("Fucking error. try again, looser")
                
            }
            
            
            
        }))
        emailAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        emailAlertController.addTextField{(emailTextFiled) in
            emailTextFiled.text = ""
            
        }
        present(emailAlertController, animated: true, completion: nil)
    }
    
    
    
    func  changePassword() {
        let passwordAllertController = UIAlertController(title: "Password", message: "Please write new password", preferredStyle: .alert)
        changeAlertProperties(alertController: passwordAllertController)
        passwordAllertController.addAction(UIAlertAction(title: "Save", style: .default, handler: {(alert: UIAlertAction) in
            
            
            
            
        }))
        passwordAllertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        passwordAllertController.addTextField { (passwordTextField)  in
            passwordTextField.text = ""
            passwordTextField.placeholder = "New password"
            passwordTextField.isSecureTextEntry = true
            
        }
        
        passwordAllertController.addTextField { (confirmPasswordTextField)  in
            confirmPasswordTextField.text = ""
            confirmPasswordTextField.placeholder = "Confirm password"
            confirmPasswordTextField.isSecureTextEntry = true
            
            
        }
        
        present(passwordAllertController, animated: true, completion: nil)
    }
    
    
    func changeAlertProperties(alertController: UIAlertController) {
        let subview = alertController.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = UIColor.green
        alertContentView.layer.cornerRadius = 15;
        alertContentView.layer.borderWidth = 3;
        alertContentView.layer.borderColor = UIColor.white.cgColor
    }
    func changeIsGood() {
        let alert = UIAlertController(title: "DONE", message: nil, preferredStyle: .alert)
        changeAlertProperties(alertController: alert)
        self.present(alert, animated: true, completion: {self.dismiss(animated: true, completion: nil)})
    }
    
    func ValidatorForEmail( isEmail: String)-> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: isEmail, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, isEmail.count)) != nil
        } catch {
            return false
        }
    }
    
    func changeMapType() {
        let mapTypeAlertController = UIAlertController(title: "Change map type", message: "Please choose map type", preferredStyle: .alert)
        changeAlertProperties(alertController: mapTypeAlertController)
        let standartType = UIAlertAction(title: "Standart", style: .default) { (action) in
            self.defaults.set(1, forKey: "mapType")
            print(UserDefaults.standard.integer(forKey: "mapType"))
            
        }
        let satelliteType = UIAlertAction(title: "Satellite", style: .default) { (action) in
            self.defaults.set(2, forKey: "mapType")
            print(UserDefaults.standard.integer(forKey: "mapType"))
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        mapTypeAlertController.addAction(standartType)
        mapTypeAlertController.addAction(satelliteType)
        mapTypeAlertController.addAction(cancelAction)
        present(mapTypeAlertController, animated: true, completion: nil)
        
    }
    



}






