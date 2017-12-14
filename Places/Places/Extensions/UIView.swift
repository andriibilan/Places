//
//  Extension for view.swift
//  Places
//
//  Created by andriibilan on 11/26/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//
import UIKit


extension UIView
{
    func setCorenerAndShadow(_ view: UIView){
        let borderView = view
        borderView.frame = borderView.bounds
        borderView.layer.cornerRadius = 8
        borderView.layer.borderColor = UIColor.black.cgColor
       // borderView.layer.borderWidth = 1.0
        borderView.layer.masksToBounds = true

    }
  
}
