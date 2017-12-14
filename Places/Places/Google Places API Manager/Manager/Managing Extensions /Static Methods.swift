//
//  Static Methods.swift
//  Places
//
//  Created by andriibilan on 12/4/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation
import UIKit


extension GooglePlacesManager{
    static func makeConforming(type: String) -> String {
        var conformingType = type.lowercased()
        
        if let regEx = try? NSRegularExpression(pattern: "\\s+") {
            conformingType = regEx.stringByReplacingMatches(in: conformingType, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: conformingType.count), withTemplate: "_")
            if let regExForBounds = try? NSRegularExpression(pattern: "(^_+)|(_+$)") {
                conformingType = regExForBounds.stringByReplacingMatches(in: conformingType, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: conformingType.count), withTemplate: "")
            }
        }
        return conformingType
    }
}
