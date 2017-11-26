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
    
    
    @IBOutlet weak var userNameLabelText: UILabel!
    @IBOutlet weak var emailLabeltext: UILabel!
    
    @IBOutlet weak var phoneLabelText: UILabel!
    @IBOutlet weak var passwordLabelText: UILabel!
    
    let userID = (Auth.auth().currentUser?.uid)!
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getProfileData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getProfileData() {
        ref.child("Users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let user = Users(snapshot: snapshot)
            self.emailLabeltext.text = user.email
//            self.passwordLabelText.text = user.password
            self.phoneLabelText.text = user.phone
            
            let profileImageURL = user.ImageUrl
            let url = URL(string: profileImageURL!)
            let data = try? Data(contentsOf: url!)
            
            DispatchQueue.main.async {
                self.profileImage.image = UIImage(data: data!)
            }
        })
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try? Auth.auth().signOut()
                
                if Auth.auth().currentUser == nil {
                    let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
                    self.present(loginVC, animated: true, completion: nil)
                }
            }
        }
    }
    
}
