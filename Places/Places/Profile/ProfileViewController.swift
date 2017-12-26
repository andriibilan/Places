
//  ProfileViewController.swift
//  Places
//
//  Created by Yurii Vients on 11/22/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

let offsetHeaderStop:CGFloat = 30.0 // At this offset the Header stops its transformations
let offsetBLabelHeader:CGFloat = 105.0 // At this offset the Black label reaches the Header
let distanceWLabelHeader:CGFloat = 100.0 // The distance between the bottom of the Header and the top of the White Label

class ProfileViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var profileImage: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet var headerImageView:UIImageView!
    @IBOutlet var headerBlurImageView:UIImageView!
    
    private var blurEffectView: UIVisualEffectView?
    private let transition = CustomTransitionAnimator()
    private var messageText : String!
    
    private let userID = (Auth.auth().currentUser?.uid)!
    private let ref = Database.database().reference()
    var authService = AuthService()
    var validator = Validator()
    let blurEffect = UIBlurEffect(style: .light)
    var formatter = NumberFormatter()
    
    @IBOutlet weak var dismissButton: UIButton! {
        didSet {
            dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
            dismissButton.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 180))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfileData()
        profileBackground()
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        // Header - Blurred Image
        
        headerBlurImageView = UIImageView(frame: header.bounds)
        headerImageView?.image = UIImage(named: "lviv")
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        headerBlurImageView?.contentMode = UIViewContentMode.scaleAspectFill
        headerBlurImageView?.alpha = 0.0
        header.insertSubview(blurEffectView!, belowSubview: headerLabel)
        header.clipsToBounds = true
    }
    
    func profileBackground() {
        headerImageView = UIImageView(frame: header.bounds)
        headerImageView?.image = UIImage(named: "lviv")
        headerImageView?.contentMode = UIViewContentMode.scaleAspectFill
        header.insertSubview(headerImageView, belowSubview: headerLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    
    func getProfileData() {
        ref.child("Users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let user = Users(snapshot: snapshot)
            self.emailTextField.text = user.email
            self.nameTextField.text = user.firstName
            self.headerLabel.text = user.firstName
            self.phoneTextField.text = user.phone
            let profileImageURL = user.ImageUrl
            
            let url = URL(string: profileImageURL!)
            let data = try? Data(contentsOf: url!)
            
            DispatchQueue.main.async {
                self.profileImage.image = UIImage(data: data!)
            }
        })
    }
    
    
    func alertAction(_ message: String) {
        let alertMessage = UIAlertController(title: "Oops!", message: message , preferredStyle: .alert)
        alertMessage.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertMessage, animated: true, completion: nil)
    }
    
    
    @IBAction func logOutButton(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try? Auth.auth().signOut()
                
                if Auth.auth().currentUser == nil {
                    performSegue(withIdentifier: "showLoginAfterLogOut", sender: self)
                }
            }
        }
    }
    
    @IBAction func dismissButtonTaped(_ sender: UIButton) {
        if (nameTextField.text?.isEmpty)! {
            messageText = "Please complete all fields."
            alertAction(messageText)
            
            return
        }
        if !validator.isValidEmail(email: emailTextField.text!) {
            messageText = "Please enter your correct email."
            alertAction(messageText)
            
            return
        }
        
        authService.updateUserInfo(userName: nameTextField.text!, email: emailTextField.text!, phone: phoneTextField.text!, profileImage: nil)
        performSegue(withIdentifier: "unwindFromProfile", sender: self)
        
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        chooseImage()
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
        if segue.identifier == "showLoginAfterLogOut" {
            let secondVC = segue.destination as! LoginViewController
            secondVC.transitioningDelegate = self
            secondVC.modalPresentationStyle = .custom
        }
    }
}

//MARK: ImagePickerController
extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            print("Enter Choose image")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let images  = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        profileImage.image = images
        picker.dismiss(animated: true, completion: { self.authService.updateUserInfo(userName: self.nameTextField.text!, email: self.emailTextField.text!, phone: self.phoneTextField.text!, profileImage: self.profileImage.image!)
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController:  UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        // PULL DOWN
        if offset < 0 {
            let headerScaleFactor:CGFloat = -(offset) / header.bounds.height
            let headerSizevariation = ((header.bounds.height * (1.0 + headerScaleFactor)) - header.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            header.layer.transform = headerTransform
        }
            // SCROLL UP/DOWN
        else {
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offsetHeaderStop, -offset), 0)
            let labelTransform = CATransform3DMakeTranslation(0, max(-distanceWLabelHeader, 20 - offset), 0)
            headerLabel.layer.transform = labelTransform
            
            // Blur
            blurEffectView?.alpha = min (0.8, (offset + 20 - offsetBLabelHeader))
            blurEffectView?.frame = view.bounds
            
            // Avatar
            let avatarScaleFactor = (min(offsetHeaderStop, offset)) / profileImage.bounds.height / 1.4 // Slow down the animation
            let avatarSizeVariation = ((profileImage.bounds.height * (1.0 + avatarScaleFactor)) - profileImage.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
            if offset <= offsetHeaderStop {
                if profileImage.layer.zPosition < header.layer.zPosition{
                    header.layer.zPosition = 0
                }
            } else {
                if profileImage.layer.zPosition >= header.layer.zPosition{
                    header.layer.zPosition = 2
                }
            }
        }
        
        // Apply Transformations
        header.layer.transform = headerTransform
        profileImage.layer.transform = avatarTransform
    }
    
}

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case nameTextField:
            guard let text = nameTextField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 20
            
        case phoneTextField:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            let inputNumber = textField.text
            
            if (inputNumber?.count)! < 19
            {
                phoneTextField.text = formatter.formatPhoneNumber(inputNumber!)
                
            } else {
                let newLength = (inputNumber?.count)! + string.count - range.length
                return newLength <= 19
            }
            return allowedCharacters.isSuperset(of: characterSet)
        default:
            break
        }
        return true
    }
}


