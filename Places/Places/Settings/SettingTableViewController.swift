//
//  TableViewController.swift
//  Places
//
//  Created by andriibilan on 11/23/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    let password = ChangePassword()
    let email = ChangeEmail()
    let defaults = UserDefaults.standard

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
    
  private  func valueForMetres() {
        let radiusValue = defaults.integer(forKey: "Radius")
        if radiusValue < 1000 {
            searchRadius.text = NSLocalizedString("Search Radius:", comment: "") + " \(radiusValue ) m"
        } else {
            searchRadius.text = NSLocalizedString("Search Radius:", comment: "") + " \((Double(radiusValue).kilometr).rounded(toPlaces: 2)) km"
        }
    }
    
    private func valueForMiles() {
        searchRadius.text = NSLocalizedString("Search Radius:", comment: "") + " \(String((defaults.double(forKey: "Radius").miles).rounded(toPlaces: 2))) mi"
    }
    
   private func updateSliderValue (distanceIsKms: Bool) {
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
    
    private func updateMapTypeValue(map: Int) {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0 :
                email.changeEmail(controller: self)
            case 1:
                password.changePassword(controller: self)
            default:
                break
            }
        }
    }
}
