//
//  LoginViewController.swift
//  Places
//
//  Created by Yurii Vients on 11/22/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, AuthServiceDelegate{
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
	var authService = AuthService()
	
	@IBOutlet weak var dismissButton: UIButton!{
		didSet{
			dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
			dismissButton.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 180))
		}
	}
	
	@IBAction func dismissButtonTaped(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindFromLogin", sender: self)
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
         authService.delegate = self
    }
    
    func transitionToProfile() {
        let profileVC = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        self.present(profileVC, animated: true, completion: nil)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        guard let email = emailTextField.text else { return}
        guard let password = passwordTextfield.text else { return}
        
        if email.isEmpty || password.isEmpty {
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            authService.logIn(email: email, password: password)
        }
    }
    
}

