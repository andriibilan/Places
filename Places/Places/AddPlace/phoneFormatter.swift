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
        if let cursorPosition = display.position(from: display.beginningOfDocument, offset: position[0]) {
            display.selectedTextRange = display.textRange(from: cursorPosition, to: cursorPosition)
        }
    }
    
    func backspace() {
        var pos: Int = position[0]
        if current > 0 {
            current -= 1
            curStr[position[current]] = replChar
            pos = position[current]
        }
        display.text = String(curStr)
        
        //if let selectedRange = display.selectedTextRange {
        //    let screenCursorPosition = display.offset(from: display.beginningOfDocument, to: selectedRange.start)
        //}
        
        if let cursorPosition = display.position(from: display.beginningOfDocument, offset: pos) {
            display.selectedTextRange = display.textRange(from: cursorPosition, to: cursorPosition)
        }
    }
    
    func printNumber(newDigit: Character) {
        var pos: Int = position[position.count - 1] + 1
        if current < position.count {
            pos = position[current] + 1
            curStr[position[current]] = newDigit
            current += 1
        }
        display.text = String(curStr)
        if let cursorPosition = display.position(from: display.beginningOfDocument, offset: pos) {
            display.selectedTextRange = display.textRange(from: cursorPosition, to: cursorPosition)
        }
    }
}
