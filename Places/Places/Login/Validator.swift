//
//  Validator.swift
//  Places
//
//  Created by Yurii Vients on 11/23/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation

class Validator {
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return pred.evaluate(with: email)
    }
    
    func isValidPassword(password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", ".{8,}")
        return passwordTest.evaluate(with: password)
    }
    
//    func isValidPhoneNumber(testStr: String) -> Bool {
//        let phoneRegEx = "[+(-)0123456789]"
////        let phoneRegEx = "[+][3][8][(][0][0-9]{2}[)]" //[ ][0-9]{2}[-][0-9]{2}[-][0-9]{3}
//        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
//        return phoneTest.evaluate(with: testStr)
//    }
    
}

