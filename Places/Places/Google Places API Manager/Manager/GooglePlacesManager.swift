//
//  SearchManager.swift
//  Places
//
//  Created by Nazarii Melnyk on 11/23/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

// json nearby request example: https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=37.7858956,-122.4067728&radius=50&key=AIzaSyCOrfXohc5LOn-J6aZQHqXc0nmsYEhAxQQ

import Foundation
import UIKit

class GooglePlacesManager{
    var delegate: GooglePlacesManagerDelegate?
    
    // places storage
    internal var foundedPlaces = [Place]()
    var getFoundedPlaces: [Place]{
        return foundedPlaces
    }
    // * * *
    
    internal var apiKey: String = "none"
    var getApiKey: String{
        return apiKey
    }
    
    internal var radius: Int = 100.m
    var getRadius: Int{
        return radius
    }
    internal var currentLocation = Location.currentLocation()
    var getCurrentLocation: Location{
        return currentLocation
    }
    internal var filters = [PlaceType]()
    var getFilters: [PlaceType]{
        return filters
    }
    
    internal var allPlacesLoaded = false
    var isAllPlacesLoaded: Bool{
        return allPlacesLoaded
    }
    
    // MARK: - Init
    /// Initialization of nearby search
    init(apiKey: String, radius: Int, currentLocation: Location, filters: [PlaceType], delegate: GooglePlacesManagerDelegate?, completion: @escaping ([Place]?) -> Void) {
        self.apiKey = apiKey
        self.radius = radius
        self.currentLocation = currentLocation
        self.filters = filters
        self.delegate = delegate
        
        fetchPlaces(completion: completion)
    }
}
