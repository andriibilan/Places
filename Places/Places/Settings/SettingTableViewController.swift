//
//  TableViewController.swift
//  Places
//
//  Created by andriibilan on 11/23/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
   let validator = Validator()
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
            searchRadius.text = "Search Radius: \(radiusValue ) m"
        } else {
            searchRadius.text = "Search Radius: \((Double(radiusValue).kilometr).rounded(toPlaces: 2)) km"
        }
    }
    
    private func valueForMiles() {
        searchRadius.text = "Search Radius: \(String((defaults.double(forKey: "Radius").miles).rounded(toPlaces: 2))) mi"
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
                changeEmail()
            case 1:
                changePassword()
            default:
                break
            }
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
        alertContentView.layer.cornerRadius = 15
        alertContentView.layer.borderWidth = 3
        alertContentView.layer.borderColor = UIColor.white.cgColor
    }
}
