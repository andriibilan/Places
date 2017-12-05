//
//  AddNewPlaceController.swift
//  Places
//
//  Created by adminaccount on 11/24/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class AddNewPlaceController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UITextInputTraits, SetCategory {

    let destination = "toAddBoard"
    
    let segueToMain = "goBack"
    
    let phoneTemplate = "+380(__) ___ __ __"
    
    let underLiner: Character = "_"
    
    var phoneFormat: phoneNumberFormatter?
    
    @IBOutlet weak var inside: UIView!
    
    @IBOutlet weak var scroll: UIScrollView!
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var addres: UITextField!
    
    @IBOutlet weak var number: UITextField!
   
    @IBOutlet weak var list: UIView!
    
    @IBOutlet weak var category: UITextField!
    
    @IBOutlet weak var website: UITextField!
    
    @IBOutlet weak var forUpKeyboard: NSLayoutConstraint!
    
    @IBOutlet weak var insideHeight: NSLayoutConstraint!
    
    @IBOutlet weak var upper: NSLayoutConstraint!
    
    var unseen: UIView?
    
    var categoryListVisibility = true
    
    var keyBoardPresent = true
    
    var offset: CGFloat = 0
    //var location: [String: Double]?
    var location: Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.delegate = self
        addres.delegate = self
        number.delegate = self
        category.delegate = self
        website.delegate = self
        
        scroll.delegate = self
        
        list.isHidden = categoryListVisibility
        
        unseen = UIView.init(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        category.inputView = unseen
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        phoneFormat = phoneNumberFormatter(field: number, ins: phoneTemplate, replacmentCharacter: underLiner)
    }
    
    @objc func dismissKeyboard() {
        if keyBoardPresent == true {
            let newHeight = scroll.contentSize.height - offset
            scroll.contentSize = CGSize(width: UIScreen.main.bounds.width, height: newHeight)
            insideHeight.constant -= offset
            upper.constant = 18
            keyBoardPresent = false
        }
        view.endEditing(true)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            offset = keyboardSize.height
            let newHeight = scroll.contentSize.height + offset
            scroll.contentSize = CGSize(width: UIScreen.main.bounds.width, height: newHeight)
            insideHeight.constant += offset
            upper.constant += offset
            keyBoardPresent = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let frame = textField.superview?.convert(textField.frame.origin, to: nil)// convertPoint:aView.frame.origin toView:nil
      
        if textField == category {
            list.isHidden = false
        }
        else {
            list.isHidden = true
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField != category {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame = CGRect(x: self.view.frame.origin.x, y:self.view.frame.origin.y + 200, width: self.view.frame.size.width, height: self.view.frame.size.height);
                
            })
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField != category {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame = CGRect(x: self.view.frame.origin.x, y:self.view.frame.origin.y - 200, width: self.view.frame.size.width, height: self.view.frame.size.height);
                
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
    
    func scrollRectToVisible(_ rect: CGRect,  animated: Bool) {
        //print("scroll")
    }
    
    @IBAction func postToGoogle(_ sender: UIButton) {
    //    NotificationCenter.default.removeObserver(self)
     //   print("deinit")
        
      let coordinates: [String: Double] = [
        "lat": (location?.latitude)!,
        "lng": (location?.longitude)!
      ]
       //wrap!!!!
      let jsonArray: [String: Any] =
             [ "location": coordinates,
               "accuracy": 200,
               "name": name.text!,
               "phone_number": number.text!,
               "address": addres.text!,
               "types": [category.text],
               "language": "en-AU"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonArray)
        //let YOUR_API_KEY: Int = AIzaSyB1AHQpRBMU2vc6T7guiqFz2f5_CUyTRRc
        //let YOUR_API_KEY: String = "AIzaSyC-bJQ22eXNhviJ9nmF_aQ0FSNWK2mNlVQ"
        
        var answer = [String: Any] ()
        
        if let url = URL(string: "https://maps.googleapis.com/maps/api/place/add/json?key=AIzaSyB1AHQpRBMU2vc6T7guiqFz2f5_CUyTRRc"){
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
        
        let requestStatus: String? = answer["status"] as? String
        print(answer["status"] as Any)
        print(requestStatus as Any)
        
        let alert = UIAlertController(title: "YOUR REQUEST WAS SENDED", message: "you request status is \(requestStatus ?? "unknown")", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cansel(_ sender: UIButton) {
    //    NotificationCenter.default.removeObserver(self)
    //    print("deinit")
        dismiss(animated: true, completion: nil)
    }
    
    func setCategoryText(newText: String) {
        category.text = newText
        list.isHidden = true
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
}
