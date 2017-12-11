//
//  PlaceType.swift
//  Places
//
//  Created by Nazarii Melnyk on 11/27/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation

enum PlaceType: String{
    case bar
    case cafe
    case restaurant
    case bank
    case night_club
    case museum
    case beauty_salon
    case pharmacy
    case hospital
    case bus_station
    case gas_station
    case university
    case police
    case church
    case cemetery
    case park
    case gym
    
    var printableStyle: String {
        return self.rawValue.replacingOccurrences(of: "_", with: " ").capitalized
    }
    
    // unsupported by application types
    case accounting
    case caseairport
    case amusement_park
    case aquarium
    case art_gallery
    case atm
    case bakery
    case bicycle_store
    case book_store
    case bowling_alley
    case campground
    case car_dealer
    case car_rental
    case car_repair
    case car_wash
    case casino
    case city_hall
    case clothing_store
    case convenience_store
    case courthouse
    case dentist
    case department_store
    case doctor
    case electrician
    case electronics_store
    case embassy
    case fire_station
    case florist
    case funeral_home
    case furniture_store
    case hair_care
    case hardware_store
    case hindu_temple
    case home_goods_store
    case insurance_agency
    case jewelry_store
    case laundry
    case lawyer
    case library
    case liquor_store
    case local_government_office
    case locksmith
    case lodging
    case meal_delivery
    case meal_takeaway
    case mosque
    case movie_rental
    case movie_theater
    case moving_company
    case painter
    case parking
    case pet_store
    case physiotherapist
    case plumber
    case post_office
    case real_estate_agency
    case roofing_contractor
    case rv_park
    case school
    case shoe_store
    case shopping_mall
    case spa
    case stadium
    case storage
    case store
    case subway_station
    case synagogue
    case taxi_stand
    case train_station
    case transit_station
    case travel_agency
    case veterinary_care
    case zoo
    // additional unsupported types
    case administrative_area_level_1
    case administrative_area_level_2
    case administrative_area_level_3
    case administrative_area_level_4
    case administrative_area_level_5
    case colloquial_area
    case country
    case establishment
    case finance
    case floor
    case food
    case general_contractor
    case geocode
    case health
    case intersection
    case locality
    case natural_feature
    case neighborhood
    case place_of_worship
    case political
    case point_of_interest
    case post_box
    case postal_code
    case postal_code_prefix
    case postal_code_suffix
    case postal_town
    case premise
    case room
    case route
    case street_address
    case street_number
    case sublocality
    case sublocality_level_4
    case sublocality_level_5
    case sublocality_level_3
    case sublocality_level_2
    case sublocality_level_1
    case subpremise
    
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
