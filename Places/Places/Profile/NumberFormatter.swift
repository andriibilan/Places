//
//  NumberFormatter.swift
//  Places
//
//  Created by Yurii Vients on 12/21/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation

class NumberFormatter {
    
    func formatPhoneNumber(_ str: String) -> String {
        
        var originalText = str
        
        if (originalText.count) == 0
        {
            originalText.append("+38")
        }
        if (originalText.count) == 3
        {
            originalText.append(" (0")
        }
        if (originalText.count) == 8
        {
            originalText.append(") ")
        }
        if (originalText.count) == 12
        {
            originalText.append("-")
        }
        if (originalText.count) == 15
        {
            originalText.append("-")
        }
        
        return originalText
    }
}
