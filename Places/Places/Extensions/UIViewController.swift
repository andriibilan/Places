//
//  UIViewController.swift
//  Places
//
//  Created by Nazarii Melnyk on 12/2/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String = "Error", message: String = "Something goes wrong"){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func resultAlert(text: String, message: String?, color: UIColor) {
        let alert = UIAlertController(title: text, message: message, preferredStyle: .alert)
        alert.changeAlertProperties(alertController: alert, color: color)
        present(alert, animated: true, completion: {
            sleep(1)
            self.dismiss(animated: true, completion: nil)
        })
    }
}
