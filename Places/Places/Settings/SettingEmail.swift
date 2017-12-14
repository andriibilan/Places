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

class ChangeEmail {
    let validator = Validator()
    var dataBaseReference: DatabaseReference! {
        return Database.database().reference()
    }
    
    func changeEmail(controller: UIViewController) {
        let emailAlertController = UIAlertController(title: "e-mail", message: "Please write new e-mail", preferredStyle: .alert)
        emailAlertController.changeAlertProperties(alertController: emailAlertController, color: .white)
        emailAlertController.addAction(UIAlertAction(title: "Save", style: .default, handler: {(alert: UIAlertAction) in
            self.checkEmail(newEmail: emailAlertController.textFields![0].text!, controller: controller)
        }))
        emailAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        emailAlertController.addTextField {(emailTextFiled) in
            emailTextFiled.placeholder = "please write new e-mail"
        }
        controller.present(emailAlertController, animated: true, completion: nil)
    }
    
    private func checkEmail(newEmail: String, controller: UIViewController) {
        guard validator.isValidEmail(email: newEmail) else {
            return controller.resultAlert(text: "Error", message:"Please write correct e-mail", color: .red)
        }
        updateMail(mailString: newEmail, controller: controller)
    }

   private func updateMail (mailString: String, controller: UIViewController) {
        let userID : String = (Auth.auth().currentUser?.uid)!
        if let user = Auth.auth().currentUser {
            user.updateEmail(to: mailString, completion: {(error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    let emailUpdate = ["email": mailString]
                    self.dataBaseReference.child("Users").child(userID).updateChildValues(emailUpdate)
                    controller.resultAlert(text: "DONE", message:"You have successfully updated your email", color: .green)
                }
            })
        }
    }
}
