//
//  TableViewController.swift
//  Places
//
//  Created by andriibilan on 11/23/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SettingTableViewController: UITableViewController {
    let defaults = UserDefaults.standard

    
    var dataBaseReference: DatabaseReference! {
        return Database.database().reference()
    }
    @IBOutlet weak var distanceSegment: UISegmentedControl!
    @IBOutlet weak var searchRadius: UILabel!
    @IBOutlet weak var sliderValue: UISlider!
    @IBOutlet weak var mapTypeSegment: UISegmentedControl!
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
            searchRadius.text = "Search Radius: \((Double(radiusValue).kilometr).rounded(toPlaces: 2)) km"
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
    
    
    @IBAction func changeMapType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.defaults.set(1, forKey: "mapType")
        case 1:
            self.defaults.set(2, forKey: "mapType")
        default:
            break
        }
    }
    
    func updateMapTypeValue(map: Int) {
        switch map {
        case 1:
            mapTypeSegment.selectedSegmentIndex = 0
        case 2:
            mapTypeSegment.selectedSegmentIndex = 1
        default:
            break
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateSliderValue(distanceIsKms: defaults.bool(forKey: "distanceIskm"))
        updateMapTypeValue(map: defaults.integer(forKey: "mapType"))
        print(Float(defaults.double(forKey: "Radius")))
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
                return "User Settings"
        } else {
            return "Map Settings"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0 :
                changeEmail()
            case 1:
                changePassword()
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
        changeAlertProperties(alertController: emailAlertController, color: .white)
        emailAlertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (alert: UIAlertAction) in
            if self.ValidatorForEmail(isEmail: emailAlertController.textFields![0].text!) {
                self.updateMail(mailString: emailAlertController.textFields![0].text!)
            } else {
                self.resultAlert(text: "Error", message: "Please write correct e-mail", color: .red)
            }
        }))
        emailAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        emailAlertController.addTextField{(emailTextFiled) in
            emailTextFiled.placeholder = "please write new e-mail"
        }
        present(emailAlertController, animated: true, completion: nil)
    }
    
    func updateMail (mailString: String) {
         let userID : String = (Auth.auth().currentUser?.uid)!
        if let user = Auth.auth().currentUser {
            user.updateEmail(to: mailString, completion: { (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    let emailUpdate = ["email": mailString]
                    self.dataBaseReference.child("Users").child(userID).updateChildValues(emailUpdate)
                    self.resultAlert(text: "DONE", message: "You have successfully updated your email", color: .white)
                }
            })
        }
    }
    
    func  changePassword() {
        var newPassword = ""
        var confirmPassword = ""
        let passwordAllertController = UIAlertController(title: "Password", message: "Please write new password", preferredStyle: .alert)
        changeAlertProperties(alertController: passwordAllertController, color: .white)
        passwordAllertController.addAction(UIAlertAction(title: "Save", style: .default, handler: {(alert: UIAlertAction) in
            newPassword = passwordAllertController.textFields![0].text!
            confirmPassword = passwordAllertController.textFields![1].text!
            if newPassword == confirmPassword {
                self.updatePassword(password: newPassword)
            } else {
                self.resultAlert(text: "Please write correct  confirm password", message: nil, color: .red)
            }
        }))
        passwordAllertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        passwordAllertController.addTextField { (passwordTextField)  in
            passwordTextField.placeholder = "New password"
            passwordTextField.isSecureTextEntry = true
            newPassword = passwordTextField.text!
        }
        
        passwordAllertController.addTextField { (confirmPasswordTextField)  in
            confirmPasswordTextField.placeholder = "Confirm password"
            confirmPasswordTextField.isSecureTextEntry = true
            confirmPassword = confirmPasswordTextField.text!
        }
        present(passwordAllertController, animated: true, completion: nil)
    }
    
    func updatePassword(password: String) {
        if let user = Auth.auth().currentUser {
            user.updatePassword(to: password, completion: { (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.resultAlert(text: "DONE", message: "You have successfully updated your password", color: .green)
                }
            })
        }
    }
    
    func resultAlert(text: String, message: String?, color: UIColor) {
        let alertBad = UIAlertController(title: text, message: message, preferredStyle: .alert)
        changeAlertProperties(alertController: alertBad, color: color)
        self.present(alertBad, animated: true, completion: {
            sleep(1)
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func changeAlertProperties(alertController: UIAlertController, color: UIColor) {
        let subview = alertController.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = color
        alertContentView.layer.cornerRadius = 15;
        alertContentView.layer.borderWidth = 3;
        alertContentView.layer.borderColor = UIColor.white.cgColor
    }
    
    func ValidatorForEmail( isEmail: String)-> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: isEmail, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, isEmail.count)) != nil
        } catch {
            return false
        }
    }


}






