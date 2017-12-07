//
//  Array.swift
//  Places
//
//  Created by Nazarii Melnyk on 12/6/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
