//
//  AddNewPlaceController.swift
//  Places
//
//  Created by adminaccount on 11/24/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class AddNewPlaceController: UIViewController, UITextFieldDelegate, SetCategory {

    let destination = "toAddBoard"
    
    let segueToMain = "goBack"
    
    var phoneFormat: phoneNumberFormatter?
    
    @IBOutlet weak var number: UITextField!
   
    @IBOutlet weak var list: UIView!
    
    @IBOutlet weak var category: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        number.delegate = self
        category.delegate = self
        
        list.isHidden = true
        phoneFormat = phoneNumberFormatter(field: number, ins: "+380(_-_) _-_-_ _-_ _-_", replacmentCharacter: "_")
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
    

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == category{
            list.isHidden = false
        }
        return true
    }
    /*
    @IBAction func categoryTouched(_ sender: UITextField) {
        print("---------------")
    }*/
    
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

    @IBAction func postToGoogle(_ sender: UIButton) {
        /*
        POST https://maps.googleapis.com/maps/api/place/add/json?key=YOUR_API_KEY HTTP/1.1
        Host: maps.googleapis.com
        
        {
            "location": {
                "lat": -33.8669710,
                "lng": 151.1958750
            },
            "accuracy": 50,
            "name": "Google Shoes!",
            "phone_number": "(02) 9374 4000",
            "address": "48 Pirrama Road, Pyrmont, NSW 2009, Australia",
            "types": ["shoe_store"],
            "website": "http://www.google.com.au/",
            "language": "en-AU"
        }
         //////////
         let json: [String: Any] = ["title": "ABC",
         "dict": ["1":"First", "2":"Second"]]
         
         let jsonData = try? JSONSerialization.data(withJSONObject: json)
         
         // create post request
         let url = URL(string: "http://httpbin.org/post")!
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         
         // insert json data to the request
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
        
        let alert = UIAlertController(title: "SORRY", message: "GOOGLE is temporarily unavailable", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.cancel, handler: { action in
            self.performSegue(withIdentifier: self.segueToMain, sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setCategoryText(newText: String){
        category.text = newText
        list.isHidden = true
    }
}
