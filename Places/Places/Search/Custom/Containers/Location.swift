//
//  Location.swift
//  Places
//
//  Created by Nazarii Melnyk on 11/21/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import Foundation
import CoreLocation

struct Location{
    // широта
    var latitude: Double
    // довгота
    var longitude: Double
    
    static func Lviv() -> Location{
        // probably need to swap values
        return Location(latitude: 49.841856, longitude: 24.031530)
    }
    
    static func currentLocation() -> Location{
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        
        let location = manager.location
        
        return Location(latitude: location!.coordinate.latitude,
                        longitude: location!.coordinate.longitude)
    }
}
