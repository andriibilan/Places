//
//  SettingPassword.swift
//  Places
//
//  Created by andriibilan on 12/12/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit
import Firebase

class ChangePassword {
    let validator = Validator()
    
    func  changePassword(controller: UIViewController) {
        var newPassword = ""
        var confirmPassword = ""
        let passwordAllertController = UIAlertController(title: "Password", message: "Please write new password", preferredStyle: .alert)
        passwordAllertController.changeAlertProperties(alertController: passwordAllertController, color: .white)
        passwordAllertController.addAction(UIAlertAction(title: "Save", style: .default, handler: {(alert: UIAlertAction) in
            newPassword = passwordAllertController.textFields![0].text!
            confirmPassword = passwordAllertController.textFields![1].text!
            if newPassword == confirmPassword && self.validator.isValidPassword(password: newPassword) {
                self.updatePassword(password: newPassword, controller: controller)
            } else {
               controller.resultAlert(text: "Please write correct  confirm password", message: nil, color: .red)
                
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
        controller.present(passwordAllertController, animated: true, completion: nil)
    }
    
    func updatePassword(password: String, controller: UIViewController) {
        if let user = Auth.auth().currentUser {
            user.updatePassword(to: password, completion: { (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                   controller.resultAlert(text: "DONE", message: "You have successfully updated your password", color: .green)
                }
            })
        }
    }
}

