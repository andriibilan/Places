//
//  phoneFormatter.swift
//  Places
//
//  Created by adminaccount on 11/28/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation
import UIKit

class phoneNumberFormatter {
    var current: Int
    var position = [Int] ()
    var curStr = [Character] ()
    var strStr: String
    var display: UITextField
    
    var replChar: Character
    
    init (field: UITextField, ins: String, replacmentCharacter: Character) {
        current = 0
        display = field
        strStr = ins
        replChar = replacmentCharacter
        display.text = strStr
        
        var i = 0
        
        for char in strStr {
            curStr.append(char)
            if char == replChar {
                position.append(i)
            }
            i += 1
        }
    }
    //textField.position(from: selectedRange.start, offset: -1)
    func backspace() {
        if current > 0 {
            current -= 1
            curStr[position[current]] = "_"
            //display.position(from: display.beginningOfDocument, offset: position[current])
        }
        display.text = String(curStr)
    }
    
    func printNumber(newDigit: Character) {
        if current < position.count {
            curStr[position[current]] = newDigit
            current += 1
            //display.position(from: display.beginningOfDocument, offset: position[current])
        }
        display.text = String(curStr)
    }
}
