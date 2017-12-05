//
//  SearchManager.swift
//  Places
//
//  Created by Nazarii Melnyk on 11/23/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

// json nearby request example: https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=37.7858956,-122.4067728&radius=50&key=AIzaSyB1AHQpRBMU2vc6T7guiqFz2f5_CUyTRRc

import Foundation
import UIKit

class GooglePlacesManager{
    // places storage
    var foundedPlaces = [Place]()
    // * * *
    
    var apiKey: String = "none"
    var radius: Int = 100.m
    var currentLocation = Location.currentLocation
    var filters = [PlaceType]()
    
    var allPlacesLoaded = false
    var loadedPlaceTypes = 0
    
    // MARK: - Init
    /// Initialization of nearby/byName search
    init(apiKey: String, radius: Int, currentLocation: Location, filters: [PlaceType], placeName: String? = nil, completion: @escaping ([Place]?, String?) -> ()) {
        self.apiKey = apiKey
        self.radius = radius
        self.currentLocation = currentLocation
        self.filters = filters
        
        if let name = placeName{
//            getBasicData(byName: <#T##String#>, ofPlaceIndex: <#T##Int?#>, ofPlace: <#T##Place?#>, completion: <#T##(Place?, String?) -> ()#>)
        } else{
            fetchPlaces(completion: completion)
        }
    }
}
