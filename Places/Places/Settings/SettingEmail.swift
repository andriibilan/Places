//
//  SettingEmail.swift
//  Places
//
//  Created by andriibilan on 12/12/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

extension SettingTableViewController {
    var dataBaseReference: DatabaseReference! {
        return Database.database().reference()
    }
    
    func changeEmail() {
        let emailAlertController = UIAlertController(title: "e-mail", message: "Please write new e-mail", preferredStyle: .alert)
        changeAlertProperties(alertController: emailAlertController, color: .white)
        emailAlertController.addAction(UIAlertAction(title: "Save", style: .default, handler: {(alert: UIAlertAction) in
            if self.validator.isValidEmail(email: emailAlertController.textFields![0].text!) {
                self.updateMail(mailString: emailAlertController.textFields![0].text!)
            } else {
                self.resultAlert(text: "Error", message:"Please write correct e-mail", color: .red)
            }
        }))
        emailAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        emailAlertController.addTextField {(emailTextFiled) in
            emailTextFiled.placeholder = "please write new e-mail"
        }
        present(emailAlertController, animated: true, completion: nil)
    }
    
    func updateMail (mailString: String) {
        let userID : String = (Auth.auth().currentUser?.uid)!
        if let user = Auth.auth().currentUser {
            user.updateEmail(to: mailString, completion: {(error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    let emailUpdate = ["email": mailString]
                    self.dataBaseReference.child("Users").child(userID).updateChildValues(emailUpdate)
                    self.resultAlert(text: "DONE", message:"You have successfully updated your email", color: .white)
                }
            })
        }
    }

}
