//
//  Double.swift
//  Places
//
//  Created by Nazarii Melnyk on 11/21/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import Foundation

extension Double{
    var mm: Double{return self / 1000}
    var m: Double{return self}
    var km: Double{return self * 1000}
    var kilometr: Double{return self / 1000}
    var miles: Double{return self * 0.000621371}
    var pow2: Double{return self*self}
}
