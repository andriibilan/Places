//
//  UserSettingTableViewController.swift
//  Places
//
//  Created by andriibilan on 11/23/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class UserSettingTableViewController: UITableViewController {
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0 :
            changeEmail()
        case 1:
            changePassword()
        default:
            break
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func changeEmail(){
        let emailAlertController = UIAlertController(title: "e-mail", message: "Please write new e-mail", preferredStyle: .alert)
        changeAlertProperties(alertController: emailAlertController)
        emailAlertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (alert: UIAlertAction) in
            
            
            
            
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
    
   
    func changeAlertProperties(alertController: UIAlertController){
        let subview = alertController.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = UIColor.green
        alertContentView.layer.cornerRadius = 15;
        alertContentView.layer.borderWidth = 3;
        alertContentView.layer.borderColor = UIColor.white.cgColor
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
   

}
