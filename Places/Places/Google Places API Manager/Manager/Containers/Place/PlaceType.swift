//
//  PlaceType.swift
//  Places
//
//  Created by Nazarii Melnyk on 11/27/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation

enum PlaceType: String{
    case bar  //"Bar"
    case cafe  //"Cafe"
    case restaurant  //"Restaurant"
    case bank  //"Bank"
    case night_club = "Night Club"
    case museum = "Museum"
    case beauty_salon = "Beauty Salon"
    case pharmacy = "Pharmacy"
    case hospital = "Hospital"
    case bus_station = "Bus Station"
    case gas_station = "Gas Station"
    case university = "University"
    case police = "Police"
    case church = "Church"
    case cemetery = "Cemetery"
    case park = "Park"
    case gym = "Gym"
    
    static var all: [PlaceType]{
        return [
            .bar,
            .cafe,
            .restaurant,
            .bank,
            .night_club,
            .museum,
            .beauty_salon,
            .pharmacy,
            .hospital,
            .bus_station,
            .gas_station,
            .university,
            .police,
            .church,
            .cemetery,
            .park,
            .gym
        ]
    }
}
