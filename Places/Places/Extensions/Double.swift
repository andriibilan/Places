//
//  Extension for Double.swift
//  Places
//
//  Created by Andrii Antoniak on 11/24/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation

extension Double {
    var mm: Double{return self / 1000}
    var m: Double{return self}
    var km: Double{return self * 1000}
    var kilometr: Double{return self / 1000}
    var miles: Double{return self * 0.000621371}
    var pow2: Double{return self*self}
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
