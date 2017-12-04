
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

let offset_HeaderStop:CGFloat = 40.0 // At this offset the Header stops its transformations
let offset_B_LabelHeader:CGFloat = 85.0 // At this offset the Black label reaches the Header
let distance_W_LabelHeader:CGFloat = 35.0 // The distance between the bottom of the Header and the top of the White Label

class ProfileViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var profileImage: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet var headerImageView:UIImageView!
    @IBOutlet var headerBlurImageView:UIImageView!
    var blurredHeaderImageView:UIImageView?
    var blurEffectView: UIVisualEffectView?
    
    private let transition = CustomTransitionAnimator()
    private var messageText : String!
    private let userID = (Auth.auth().currentUser?.uid)!
    private let ref = Database.database().reference()
    var authService = AuthService()
    var validator = Validator()
    
    @IBOutlet weak var dismissButton: UIButton!{
        didSet{
            dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
            dismissButton.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 180))
        }
    }
    
    @IBAction func dismissButtonTaped(_ sender: UIButton) {
        updateProfile()
        performSegue(withIdentifier: "unwindFromProfile", sender: self)
        
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
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        //        blurEffectView?.frame = view.bounds
        //        headerBlurImageView?.image = UIImage(named: "header_bg")?.blurredImage(withRadius: 10, iterations: 20, tintColor: UIColor.clear)
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
            self.phoneTextField.text = user.phone
            let profileImageURL = user.ImageUrl
            
            let url = URL(string: profileImageURL!)
            let data = try? Data(contentsOf: url!)
            
            DispatchQueue.main.async {
                self.profileImage.image = UIImage(data: data!)
            }
        })
    }
    
    func updateProfile() {
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
        authService.updateUserInfo(userName: nameTextField.text!, email: emailTextField.text!, phone: phoneTextField.text!, profileImage: profileImage.image!)
        
        //        if !validator.isValidPhoneNumber(testStr: phoneTextField.text!) {
        //            messageText = "Please enter your correct phone number."
        //            alertAction(messageText)
        //        } else {
        //
        //        }
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
//                      performSegue(withIdentifier: "showLoginStoryboard", sender: self)
//                    let profileVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
//                    self.present(profileVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        chooseImage()
    }
    @IBAction func editButton(_ sender: Any) {
        //        authService.updateUserInfo(userName: nameTextField.text!, email: emailTextField.text!, phone: phoneTextField.text!, profileImage: profileImage.image!)
        performSegue(withIdentifier: "unwindFromProfile", sender: self)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLoginStoryboard" {
            let secondVC = segue.destination as! LoginViewController
            secondVC.transitioningDelegate = self
            secondVC.modalPresentationStyle = .custom
        }
    }
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        transition.transitionMode = .present
//        transition.startingPoint = dismissButton.center
//        transition.circleColor = .white
//
//        return transition
//    }
//    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        transition.transitionMode = .dismiss
//        transition.startingPoint = dismissButton.center
//        transition.circleColor = #colorLiteral(red: 0.9211991429, green: 0.2922174931, blue: 0.431709826, alpha: 1)
//        
//        return transition
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showLoginAfterLogOut" {
//            let secondVC = segue.destination as! LoginViewController
//            secondVC.transitioningDelegate = self
//            secondVC.modalPresentationStyle = .custom
//        }
//    }
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

extension ProfileViewController:  UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity
        
        // PULL DOWN -----------------
        
        if offset < 0 {
            
            let headerScaleFactor:CGFloat = -(offset) / header.bounds.height
            let headerSizevariation = ((header.bounds.height * (1.0 + headerScaleFactor)) - header.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            header.layer.transform = headerTransform
        }
            
            // SCROLL UP/DOWN ------------
            
        else {
            
            // Header -----------
            
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            
            //  ------------ Label
            
            let labelTransform = CATransform3DMakeTranslation(0, max(-distance_W_LabelHeader, 20 - offset), 0)
//            nameTextField.layer.transform = labelTransform
            
            //  ------------ Blur
            
            blurEffectView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
            blurEffectView?.frame = view.bounds
            //            headerBlurImageView?.alpha = min (1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader)
            
            // Avatar -----------
            
            let avatarScaleFactor = (min(offset_HeaderStop, offset)) / profileImage.bounds.height / 1.4 // Slow down the animation
            let avatarSizeVariation = ((profileImage.bounds.height * (1.0 + avatarScaleFactor)) - profileImage.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
            
            if offset <= offset_HeaderStop {
                
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

//extension ProfileViewController: UIViewControllerTransitioningDelegate {
//    //MARK:- Custom Transition
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        transition.transitionMode = .present
//        transition.startingPoint = dismissButton.center
//        transition.circleColor = #colorLiteral(red: 0.9211991429, green: 0.2922174931, blue: 0.431709826, alpha: 1)
//
//        return transition
//    }
//
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        transition.transitionMode = .dismiss
//        transition.startingPoint = dismissButton.center
//        transition.circleColor = #colorLiteral(red: 0.9211991429, green: 0.2922174931, blue: 0.431709826, alpha: 1)
//
//        return transition
//    }
//}

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}


