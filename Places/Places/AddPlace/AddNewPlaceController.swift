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
