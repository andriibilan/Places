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

class SignUpViewController: UIViewController {
    @IBOutlet  weak var emailTextField: UITextField!
    @IBOutlet  weak var passwordTextField: UITextField!
    @IBOutlet  weak var confirmPassTextField: UITextField!
    @IBOutlet  weak var nameTextField: UITextField!
    @IBOutlet  weak var phoneTextField: UITextField!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    private var userReference: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        userReference = Database.database().reference(withPath: "Users")
    }
    
    @IBAction func selectProfileImage(_ sender: Any) {
        chooseImage()
    }
    
    @IBAction func registerAction(_ sender: Any) {
        
        if ((emailTextField.text == "") || (passwordTextField.text == "") || (nameTextField.text == "") || (phoneTextField.text == ""))
        {
            let alertController = UIAlertController(title: "Error", message: "Please complete all fields", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
        else
        {
            saveToFirebase()
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
//            self.present(vc!, animated: true, completion: nil)
        }
        
        
    }
    
    func saveToFirebase() {
        
        if let email = emailTextField.text, let password = passwordTextField.text
        {
            Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
                
                if let firebaseError = error
                {
                    print(firebaseError.localizedDescription)
                    return
                }
                
                guard let userId = user?.uid else { return }
                
                let currentUserRef = self.userReference.child("\(userId)")
                currentUserRef.setValue(user?.uid)
                
                //successfully authenticated user
                let imageName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
                
                let userInfo = currentUserRef.child("userInfo")
                
                let email = userInfo.child("email")
                let password = userInfo.child("password")
                let userName = userInfo.child("userName")
                let phone = userInfo.child("phone")
                let profileImages = userInfo.child("profileImage")
                
                if (self.profileImage.image != nil) {
                    if let uploadData = UIImagePNGRepresentation(self.profileImage.image!) {
                        
                        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                            
                            if let error = error {
                                print(error)
                                return
                            }
                            
                            if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                                profileImages.setValue(profileImageUrl)
                            }
                        })
                    }
                }
                email.setValue(self.emailTextField.text)
                userName.setValue(self.nameTextField.text)
                password.setValue(self.passwordTextField.text)
                
                phone.setValue(self.phoneTextField.text)
                
                
            })
        }
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
}

//MARK: ImagePickerController
extension SignUpViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func chooseImage() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Photo Source", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else{
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
extension SignUpViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = nameTextField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 50
    }
    
}
