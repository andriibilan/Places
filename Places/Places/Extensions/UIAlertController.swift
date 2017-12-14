//
//  UIAlertController.swift
//  Places
//
//  Created by andriibilan on 12/14/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//
import UIKit
import Foundation

extension UIAlertController {
    func changeAlertProperties(alertController: UIAlertController, color: UIColor) {
        let subview = alertController.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = color
        alertContentView.layer.cornerRadius = 15
        alertContentView.layer.borderWidth = 3
        alertContentView.layer.borderColor = UIColor.white.cgColor
    }
}
