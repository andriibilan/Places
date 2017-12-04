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
    
    let phoneTemplate = "+380(_-_) _-_-_ _-_ _-_"
    
    var phoneFormat: phoneNumberFormatter?
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var addres: UITextField!
    
    @IBOutlet weak var number: UITextField!
   
    @IBOutlet weak var list: UIView!
    
    @IBOutlet weak var category: UITextField!
    
    @IBOutlet weak var website: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        number.delegate = self
        category.delegate = self
        list.isHidden = true
        phoneFormat = phoneNumberFormatter(field: number, ins: phoneTemplate, replacmentCharacter: "_")
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
        }*/
         //////////
        let location: [String: Double] = [
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
       // let YOUR_API_KEY: Int = 0
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/add/json?key=AIzaSyC-bJQ22eXNhviJ9nmF_aQ0FSNWK2mNlVQ")!
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
       
        let alert = UIAlertController(title: "YOUR REQUEST WAS SENDED", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setCategoryText(newText: String){
        category.text = newText
        list.isHidden = true
    }
}
