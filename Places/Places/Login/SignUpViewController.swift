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

class SignUpViewController: UIViewController, AuthServiceDelegate {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPassTextField: UITextField!
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    
    @IBOutlet private weak var profileImage: UIImageView!
    
    private var messageText : String!
    var authService = AuthService()
    var validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authService.delegate = self
    }
    
    @IBAction func selectProfileImage(_ sender: Any) {
        chooseImage()
    }
    
    @IBAction func selectSignInButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        self.present(vc!, animated: true, completion: nil)
    }
    
    func transitionToProfile() {
        let profileVC = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        self.present(profileVC, animated: true, completion: nil)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        
        if (firstNameTextField.text?.isEmpty)! {
            messageText = "Please complete all fields."
            alertAction(messageText)
        }
        if !validator.isValidEmail(email: emailTextField.text!) {
            messageText = "Please enter your correct email."
            alertAction(messageText)
        }
        if !validator.isValidPhoneNumber(testStr: phoneTextField.text!) {
            messageText = "Please enter your correct phone number."
            alertAction(messageText)
        }
        if !validator.isValidPassword(password: passwordTextField.text!) && passwordTextField.text!.count <= 8 {
            messageText = "Passwords must contain at least 8 characters."
            alertAction(messageText)
        }
        if passwordTextField.text != confirmPassTextField.text {
            messageText = "Confirmed password not matched please try again."
            alertAction(messageText)
        }
        if profileImage.image == nil {
            messageText = "You need to add photo, If you want create user !"
            alertAction(messageText)
        }
        else
        {
            let pictureData = UIImageJPEGRepresentation(self.profileImage.image!, 0.20)
            authService.createUser(userName: firstNameTextField.text!, email: emailTextField.text!, phone: phoneTextField.text!, password: passwordTextField.text!, pictureData: pictureData!)
//            performSegue(withIdentifier: "ShowProfileVC", sender: nil)
        }
    }
    
    func alertAction(_ message: String) {
        let alertMessage = UIAlertController(title: "Oops!", message: message , preferredStyle: .alert)
        alertMessage.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertMessage, animated: true, completion: nil)
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case firstNameTextField:
            guard let text = firstNameTextField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 10
            
        case lastNameTextField:
            guard let text = lastNameTextField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 15
            
        case phoneTextField:
            var originalText = textField.text
            
            if (originalText?.count)! == 0
            {
                originalText?.append("+38")
            }
            if (originalText?.count)! == 3
            {
                originalText?.append(" (0")
            }
            if (originalText?.count)! == 8
            {
                originalText?.append(") ")
            }
            if (originalText?.count)! == 12
            {
                originalText?.append("-")
            }
            if (originalText?.count)! == 15
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
            
        default:
            break
        }
        return true
    }
}


