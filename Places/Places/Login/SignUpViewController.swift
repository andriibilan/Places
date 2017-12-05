//
//  SignUpViewController.swift
//  Places
//
//  Created by Yurii Vients on 11/22/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SignUpViewController: UIViewController, AuthServiceDelegate ,UIViewControllerTransitioningDelegate {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPassTextField: UITextField!
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var messageText : String!
    private let transition = CustomTransitionAnimator()
    var authService = AuthService()
    var validator = Validator()
    var activeField: UITextField?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        authService.delegate = self
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
        
    }
    
    @IBOutlet weak var dismissButton: UIButton!{
        didSet{
            dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
            dismissButton.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 180))
        }
    }
    @IBAction func dismissButtonTaped(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindFromSignUp", sender: self)
    }
    
    @IBAction func selectProfileImage(_ sender: Any) {
        chooseImage()
    }
    
    //    @IBAction func selectSignInButton(_ sender: Any) {
    //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
    //        self.present(vc!, animated: true, completion: nil)
    //    }
    
    func transitionToProfile() {
//        let profileVC = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
//        self.present(profileVC, animated: true, completion: nil)
         performSegue(withIdentifier: "ShowProfileVC", sender: nil)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        
        if (firstNameTextField.text?.isEmpty)! {
            messageText = "Please complete all fields."
//            alertAction(messageText)
            showAlertAction(text: messageText)
            return
        }
        if !validator.isValidEmail(email: emailTextField.text!) {
            messageText = "Please enter your correct email."
//            alertAction(messageText)
            showAlertAction(text: messageText)
            return
        }
        //        if !validator.isValidPhoneNumber(testStr: phoneTextField.text!) {
        //            messageText = "Please enter your correct phone number."
        //            alertAction(messageText)
        //
        //            return
        //        }
        if !validator.isValidPassword(password: passwordTextField.text!) && passwordTextField.text!.count <= 8 {
            messageText = "Passwords must contain at least 8 characters."
//            alertAction(messageText)
            showAlertAction(text: messageText)
            return
        }
        if passwordTextField.text != confirmPassTextField.text {
            messageText = "Confirmed password not matched please try again."
//            alertAction(messageText)
            showAlertAction(text: messageText)
            return
        }
        if profileImage.image == nil {
            messageText = "You need to add photo, If you want create user !"
//            alertAction(messageText)
            showAlertAction(text: messageText)
            return
        }
        let pictureData = UIImageJPEGRepresentation(self.profileImage.image!, 0.20)
        authService.createUser(userName: firstNameTextField.text!, email: emailTextField.text!, phone: phoneTextField.text!, password: passwordTextField.text!, pictureData: pictureData!)
    }
    
//    func alertAction(_ message: String) {
//        let alertMessage = UIAlertController(title: "Oops!", message: message , preferredStyle: .alert)
//        alertMessage.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//        present(alertMessage, animated: true, completion: nil)
//    }
    
    func showAlertAction(text: String) {
        let alertMessage = UIAlertController(title: "Oops!", message: text , preferredStyle: .alert)
        alertMessage.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertMessage, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProfileVC" {
            let secondVC = segue.destination as! ProfileViewController
            secondVC.transitioningDelegate = self
            secondVC.modalPresentationStyle = .custom
        }
    }
    
}

//MARK: ImagePickerController
extension SignUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImage() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Photo Source", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let images  = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        profileImage.image = images
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: TextField
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == passwordTextField {
            let scrollPoint : CGPoint = CGPoint.init(x:0, y: passwordTextField.frame.origin.y + 30)
            scrollView.setContentOffset(scrollPoint, animated: true)
        }
        else if textField == confirmPassTextField {
            let scrollPoint : CGPoint = CGPoint.init(x:0, y: confirmPassTextField.frame.origin.y + 90)
            scrollView.setContentOffset(scrollPoint, animated: true)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case firstNameTextField:
            guard let text = firstNameTextField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 10
            
        case phoneTextField:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            
            var originalText = textField.text
            
            if (originalText?.count)! == 0
            {
                originalText?.append("+38")
            }
            if (originalText?.count)! == 3
            {
                originalText?.append(" (0")
            }
            if (originalText?.count)! == 9
            {
                originalText?.append(") ")
            }
            if (originalText?.count)! == 13
            {
                originalText?.append("-")
            }
            if (originalText?.count)! == 16
            {
                originalText?.append("-")
            }
            if (originalText?.count)! == 19
            {
                guard let text = phoneTextField.text else { return true }
                let newLength = text.count + string.count - range.length
                return newLength <= 19
            }
            phoneTextField.text = originalText
            return allowedCharacters.isSuperset(of: characterSet)
        default:
            break
        }
        return true
    }
    
}



