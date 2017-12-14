//
//  AddNewPlaceController.swift
//  Places
//  Elyx
//  Created by adminaccount on 11/24/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class AddNewPlaceController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UITextInputTraits, SetCategory {

    let destination = "toAddBoard"
    let segueToMain = "goBack"
    let phoneTemplate = "+380 (XX) XXX XX XX"
    let underLiner: Character = "X"
    ///outlets
    @IBOutlet weak var inside: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var addres: UITextField!
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var list: UIView!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var website: UITextField!
    //constraints
    @IBOutlet weak var forUpKeyboard: NSLayoutConstraint!
    @IBOutlet weak var insideHeight: NSLayoutConstraint!
    @IBOutlet weak var upper: NSLayoutConstraint!
    //dummy view for category
    var unseen: UIView?
    //other classes
    var phoneFormat: phoneNumberFormatter?
    var newLocation: Location?
    //for keyboard
    var keyBoardPresent = true
    var offset: CGFloat = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.delegate = self
        addres.delegate = self
        number.delegate = self
        category.delegate = self
        website.delegate = self
        scroll.delegate = self
        
        list.isHidden = true
        
        unseen = UIView.init(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        category.inputView = unseen
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        phoneFormat = phoneNumberFormatter(field: number, ins: phoneTemplate, replacmentCharacter: underLiner)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == destination {
            let childController = segue.destination as? DlistViewController
            childController?.delegate = self
        }
    }
   
    @objc func dismissKeyboard() {
        /*if keyBoardPresent == true {
            let newHeight = scroll.contentSize.height - offset
            scroll.contentSize = CGSize(width: UIScreen.main.bounds.width, height: newHeight)
            insideHeight.constant -= offset
            upper.constant = 18
            keyBoardPresent = false
        }*/
        //list.isHidden = true
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
       /* if keyBoardPresent == false {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                offset = keyboardSize.height
                let newHeight = scroll.contentSize.height + offset
                scroll.contentSize = CGSize(width: UIScreen.main.bounds.width, height: newHeight)
                insideHeight.constant += offset
                upper.constant += offset
                keyBoardPresent = true
            }
        }*/
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == category {
          /*  if upper.constant != 18 {
                let newHeight = scroll.contentSize.height - offset
                scroll.contentSize = CGSize(width: UIScreen.main.bounds.width, height: newHeight)
                insideHeight.constant -= offset
                upper.constant = 18
                keyBoardPresent = false
            }*/
            list.isHidden = false
        }
        else {
            list.isHidden = true
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField != category {
            UIView.animate(withDuration: 0.25, animations: {
                self.view.frame = CGRect(x: self.view.frame.origin.x, y:self.view.frame.origin.y + 210, width: self.view.frame.size.width, height: self.view.frame.size.height)
            })
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField != category {
            UIView.animate(withDuration: 0.25, animations: {
                self.view.frame = CGRect(x: self.view.frame.origin.x, y:self.view.frame.origin.y - 210, width: self.view.frame.size.width, height: self.view.frame.size.height)
            })
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == number {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            
            if string.isEmpty {
                phoneFormat?.backspace()
            }
            else if allowedCharacters.isSuperset(of: characterSet) == true {
                phoneFormat?.printNumber(newDigit: string.first!)
            }
            return false
        }
        else {
            return true
        }
    }
    
    @IBAction func postToGoogle(_ sender: UIButton) {
        if checkForFields() {
            let coordinates: [String: Double] = [
                "lat": (newLocation?.latitude)!,
                "lng": (newLocation?.longitude)!
            ]
            let jsonArray: [String: Any] =
                 [ "location": coordinates,
                   "accuracy": 50,
                   "name": name.text!,
                   "phone_number": number.text!,
                   "address": addres.text!,
                   "types": [category.text],
                   "language": "en-AU"]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonArray)
            
            var answer = [String: Any] ()
            
            if let url = URL(string: "https://maps.googleapis.com/maps/api/place/add/json?key=\(AppDelegate.apiKey)"){
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = jsonData
            
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                       print(error?.localizedDescription ?? "No data")
                        return
                    }
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                       answer = responseJSON
                       print(responseJSON)
                    }
                }
                task.resume()
            }
            let _ = answer["status"]
            
            let alert = UIAlertController(title: "YOUR REQUEST WAS SENDED", message: "waiting for approval", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { action in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "WARNING", message: "all fields should be filled", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cansel(_ sender: UIButton) {
          dismiss(animated: true, completion: nil)
    }
    
    func checkForFields() -> Bool{
        if name.text != "" && addres.text != "" && number.text?.contains(underLiner) == false && category.text != "" && isValidEmail(testStr: website.text!) {
            return true
        }
        else {
            return false
        }
    }
    
    func setCategoryText(newText: String) {
        category.text = newText
        list.isHidden = true
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }    
}
