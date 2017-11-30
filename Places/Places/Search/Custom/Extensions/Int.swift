//
//  Int.swift
//  Places
//
//  Created by Nazarii Melnyk on 11/21/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import Foundation

extension Int{
    var mm: Int{return self / 1000}
    var m: Int{return self}
    var km: Int{return self * 1000}
    
    var pow2: Int{return self*self}
}
