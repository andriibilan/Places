//
//  Extension for Double.swift
//  Places
//
//  Created by Andrii Antoniak on 11/24/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
