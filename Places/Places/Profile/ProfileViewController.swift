//
//  ProfileViewController.swift
//  Places
//
//  Created by Yurii Vients on 11/22/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    let UserReference = Database.database().reference(withPath: "Users")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProfileData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getProfileData() {
        let userID : String = (Auth.auth().currentUser?.uid)!
        let ref = Database.database().reference();
        
        ref.child("Users").child(userID).child("userInfo").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            let email = value?["email"] as? String ?? ""
            self.emailTextField.text = email
            
//            let password = value?["password"] as? String ?? ""
//            self.passwordTextField.text = password
            
            let userName = value?["userName"] as? String ?? ""
            self.nameTextField.text = userName
            
            let phone = value?["phone"] as? String ?? ""
            self.phoneTextField.text = phone
            
            let profileImageURL = value?["profileImage"] as? String ?? ""
            let url = URL(string: profileImageURL)
            let data = try? Data(contentsOf: url!)
            self.profileImage.image = UIImage(data: data!)
            
            
        })
    }
    
    @IBAction func editProfilebButton(_ sender: Any) {
        
        let userID : String = (Auth.auth().currentUser?.uid)!
        let currentUserInfo = self.UserReference.child(userID)
        
        
        let userInfo = currentUserInfo.child("userInfo")
        
        let email = userInfo.child("email")
        
//        let password = userInfo.child("password")
        
        let userName = userInfo.child("userName")
        
        let phome = userInfo.child("phone")
        
        email.setValue(self.emailTextField.text)
        
//        password.setValue(self.passwordTextField.text)
        
        userName.setValue(self.nameTextField.text)
        phome.setValue(self.phoneTextField.text)
        
    }
    


}
