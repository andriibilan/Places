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
    
    let phoneTemplate = "+380(_-_) _-_-_ _-_ _-_"
    
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
    
    @IBOutlet weak var upper: NSLayoutConstraint!
    
    var unseen: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        number.delegate = self
        category.delegate = self
        scroll.delegate = self
        
        list.isHidden = true
        
        unseen = UIView.init(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        category.inputView = unseen
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        phoneFormat = phoneNumberFormatter(field: number, ins: phoneTemplate, replacmentCharacter: "_")
    }
    
    @objc func dismissKeyboard() {
         view.endEditing(true)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let newHeight = scroll.contentSize.height + keyboardSize.height
            scroll.contentSize = CGSize(width: UIScreen.main.bounds.width, height: newHeight)
            //upper.constant = keyboardSize.height
            print("keyboard \(keyboardSize.height)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        print("init keyboard")
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //name.resignFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == category{
            list.isHidden = false
        }
        return true
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
        }
        return false
    }

    
    func scrollRectToVisible(_ rect: CGRect,  animated: Bool){
        print("scroll")
    }
    
    @IBAction func postToGoogle(_ sender: UIButton) {
        NotificationCenter.default.removeObserver(self)
        print("deinit")
        /*let location: [String: Double] = [
            "lat": 49.841856,
            "lng": 24.031530
        ]
        
        let jsonArray: [String: Any] =
             ["location": location,
             "accuracy": 200,
             "name": name.text,
             "phone_number": number.text,
             "address": addres.text,
             "types": category,
             "language": "en-AU"]
         
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonArray)
        let YOUR_API_KEY: Int = AIzaSyDLxIv8iHmwytbkXR5Gs2U9rqoLixhXIXM
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/add/json?key=\(YOUR_API_KEY")!
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
               print(responseJSON)
            }
        }
        task.resume()
       */
   
        let alert = UIAlertController(title: "YOUR REQUEST WAS SENDED", message: name.text, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cansel(_ sender: UIButton) {
        NotificationCenter.default.removeObserver(self)
        print("deinit")
        dismiss(animated: true, completion: nil)
    }
    
    func setCategoryText(newText: String) {
        category.text = newText
        list.isHidden = true
    }
}
