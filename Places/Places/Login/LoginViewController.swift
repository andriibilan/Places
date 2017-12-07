//
//  LoginViewController.swift
//  Places
//
//  Created by Yurii Vients on 11/22/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, AuthServiceDelegate, UIViewControllerTransitioningDelegate {
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    var authService = AuthService()
    private let transition = CustomTransitionAnimator()
    
    @IBOutlet weak var dismissButton: UIButton!{
        didSet{
            dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
            dismissButton.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 180))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authService.delegate = self
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
    }
    
    func transitionToProfile() {
        performSegue(withIdentifier: "ShowProfile", sender: nil)
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
    
    func showAlertAction(text: String) {
        let alertMessage = UIAlertController(title: "Oops!", message: text , preferredStyle: .alert)
        alertMessage.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertMessage, animated: true, completion: nil)
    }
    //MARK:- Custom Transition
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = dismissButton.center
        transition.circleColor = #colorLiteral(red: 0.9211991429, green: 0.2922174931, blue: 0.431709826, alpha: 1)
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = dismissButton.center
        transition.circleColor = #colorLiteral(red: 0.9211991429, green: 0.2922174931, blue: 0.431709826, alpha: 1)
        
        return transition
    }
    
    @IBAction func unwindFromSignUp(segue: UIStoryboardSegue) {
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        performSegue(withIdentifier: "ShowSignUp", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSignUp" {
            let secondVC = segue.destination as! SignUpViewController
            secondVC.transitioningDelegate = self
            secondVC.modalPresentationStyle = .custom
        }
        if segue.identifier == "ShowProfile" {
            let secondVC = segue.destination as! ProfileViewController
            secondVC.transitioningDelegate = self
            secondVC.modalPresentationStyle = .custom
        }
    }
    
    @IBAction func dismissButtonTaped(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
// MARK: hidden keyboard when button tap
extension UIViewController {
    func hideKeyboardOnTap(_ selector: Selector) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

