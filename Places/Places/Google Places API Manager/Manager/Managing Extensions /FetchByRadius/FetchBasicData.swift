//
//  FetchByRadius.swift
//  Places
//
//  Created by Nazarii Melnyk on 11/29/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension GooglePlacesManager{
    // MARK: - Fetching methods
    
    /// Loads basic place data in given radius;
    /// loaded data: name, isOpen, location, icon, placeId, types, rating, photo, straightDistance
    func fetchPlaces(completion: @escaping ([Place]?, String?) -> ()){
        foundedPlaces.removeAll()
        loadedPlaceTypes = 0
        
        let jsonPlacesInRadiusRequest = """
        https://maps.googleapis.com/maps/api/place/nearbysearch/json?\
        location=\(currentLocation.latitude),\(currentLocation.longitude)&\
        radius=\(radius)&
        """
        
        if filters.isEmpty{
            let requestForAllPlaces = jsonPlacesInRadiusRequest +
            "key=\(apiKey)"
            
            print("\nPlaces in Radius: " + requestForAllPlaces)
            
            if let url = URL(string: requestForAllPlaces){
                getBasicData(from: url, completion: completion)
            } else{
                print("\nerror converting json \"Places in Radius\" request to URL")
            }
        } else{
            for filter in filters{
                let requestForCertainType = jsonPlacesInRadiusRequest +
                """
                type=\(filter.rawValue)&\
                key=\(apiKey)
                """
                
                print("\nPlaces in Radius: " + requestForCertainType)
                
                if let url = URL(string: requestForCertainType){
                    getBasicData(from: url, completion: completion)
                } else{
                    print("\nerror converting json \"Places in Radius\" request to URL")
                }
            }
        }
    }
    
    
    // MARK: - Fetching basic data
    
    /// Loads basic data values (by nearbysearch request): name, openingStatus, location, icon, placeId, types, rating, photo
    private func getBasicData(from url: URL, completion: @escaping ([Place]?, String?) -> ()){
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if error != nil{
                print("\n\tdataTask in \"fetchPlaces\": ")
                print(error!)
                return
            }
            
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let dictionary = json as! [String: Any]
                
                if let errorMessage = dictionary["error_message"] as? String{
                    completion(self?.foundedPlaces, "Basic Data gives: " + errorMessage)
                    return
                }
                
                let results = dictionary["results"] as! [[String: Any]]
                
                addingNewPlace:
                    for place in results{
                        
                        if self == nil {return}
                        for existingPlace in (self?.foundedPlaces)!{
                            if self?.getPlaceId(of: place) == existingPlace.placeId{
                                continue addingNewPlace
                            }
                        }
                        
                        let createdPlace = Place()
                        
                        self?.getName(of: place, saveTo: createdPlace)
                        self?.getOpeningStatus(of: place, saveTo: createdPlace)
                        self?.getLocation(of: place, saveTo: createdPlace)
                        self?.getIcon(of: place, saveTo: createdPlace)
                        self?.getPlaceId(of: place, saveTo: createdPlace)
                        self?.getTypes(of: place, saveTo: createdPlace)
                        self?.getRating(of: place, saveTo: createdPlace)
                        self?.getStraightDistance(to: createdPlace)
                        
                        self?.foundedPlaces.append(createdPlace)
                }
                self?.loadedPlaceTypes += 1
                
                // if all places loaded
                if self?.loadedPlaceTypes == self?.filters.count{
                    if let errorMessage = dictionary["error_message"] as? String{
                        completion(self?.foundedPlaces, "Basic Data gives: " + errorMessage)
                    } else{
                        completion(self?.foundedPlaces, nil)
                    }
                }
            } catch let jsonError{
                print("\n\tcatched in \"fetchPlaces\": ")
                print(jsonError)
            }
            }.resume()
    }
    /// Loads basic data: phone number, address, website, working schedule, photo references(used for fetching photos in future), reviews - by place name
    func getBasicData(byName searchText: String, completion: @escaping ([Place]?, String?) -> ()){
        foundedPlaces.removeAll()
        
        let jsonPlacesInRadiusRequest = """
        https://maps.googleapis.com/maps/api/place/nearbysearch/json?\
        location=\(currentLocation.latitude),\(currentLocation.longitude)&\
        radius=\(radius)&\
        key=\(apiKey)
        """
        print("\nPlaces in Radius: " + jsonPlacesInRadiusRequest)
        
        if let url = URL(string: jsonPlacesInRadiusRequest){
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if error != nil{
                    print("\n\tdataTask in \"fetchPlaces\": ")
                    print(error!)
                    return
                }
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    let dictionary = json as! [String: Any]
                    
                    if let errorMessage = dictionary["error_message"] as? String{
                        completion(self?.foundedPlaces, "Basic Data gives: " + errorMessage)
                        return
                    }
                    
                    let results = dictionary["results"] as! [[String: Any]]
                    
                        for place in results{
                            let createdPlace = Place()

                            self?.getName(of: place, saveTo: createdPlace)
                            if createdPlace.name?.hasPrefix(searchText) == true{
                                self?.getOpeningStatus(of: place, saveTo: createdPlace)
                                self?.getLocation(of: place, saveTo: createdPlace)
                                self?.getIcon(of: place, saveTo: createdPlace)
                                self?.getPlaceId(of: place, saveTo: createdPlace)
                                self?.getTypes(of: place, saveTo: createdPlace)
                                self?.getRating(of: place, saveTo: createdPlace)
                                self?.getStraightDistance(to: createdPlace)
                                
                                self?.foundedPlaces.append(createdPlace)
                            }
                    }
                    completion(self?.foundedPlaces, nil)
                } catch let jsonError{
                    print("\n\tcatched in \"fetchPlaces\": ")
                    print(jsonError)
                }
                }.resume()
        } else{
            print("\nerror converting json \"Places in Radius\" request to URL")
        }
    }
    /// Returns place "place_id" to check is place already exists
    private func getPlaceId(of place: [String: Any]) -> String{
        return place["place_id"] as! String
    }
    /// Loads place name
    private func getName(of place: [String: Any], saveTo createdPlace: Place){
        if let name = place["name"] as? String{
            createdPlace.name = name
        }
    }
    /// Loads place opening status (eather is open or not)
    private func getOpeningStatus(of place: [String: Any], saveTo createdPlace: Place){
        if let openInfo = place["opening_hours"] as? [String: Any]{
            if let isOpen = openInfo["open_now"] as? Bool{
                createdPlace.isOpen = isOpen
            }
        }
    }
    /// Loads place location
    private func getLocation(of place: [String: Any], saveTo createdPlace: Place){
        if let geometry = place["geometry"] as? [String: Any]{
            if let jsonLocation = geometry["location"] as? [String: Double]{
                let latitude = jsonLocation["lat"]!
                let longitude = jsonLocation["lng"]!
                let placeLocation = Location(latitude: latitude, longitude: longitude)
                
                createdPlace.location = placeLocation
            }
        }
    }
    /// Loads place icon
    private func getIcon(of place: [String: Any], saveTo createdPlace: Place){
        if let iconReference = place["icon"] as? String{
			createdPlace.photoReferences = [iconReference]
            if let url = URL(string: iconReference){
                if let data = try? Data(contentsOf: url){
                    createdPlace.icon = UIImage(data: data)
                }
            }
        }
    }
    /// Loads place place_id
    private func getPlaceId(of place: [String: Any], saveTo createdPlace: Place){
        if let placeId = place["place_id"] as? String{
            createdPlace.placeId = placeId
        }
    }
    /// Loads place types
    private func getTypes(of place: [String: Any], saveTo createdPlace: Place){
        if let types = place["types"] as? [String]{
            for type in types{
                if let typeAsEnum = PlaceType(rawValue: type){
                    createdPlace.types.append(typeAsEnum)
                }
            }
        }
    }
    /// Loads place rating
    private func getRating(of place: [String: Any], saveTo createdPlace: Place){
        if let rating = place["rating"] as? Double{
            createdPlace.rating = rating
        }
    }
    /// Calculates distance between two point
    private func getStraightDistance(to createdPlace: Place){
        let origin = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        
        if let destination = createdPlace.location{
            let placeLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
            
            createdPlace.distance = Int(placeLocation.distance(from: origin))
            createdPlace.distanceFromLocation = currentLocation
        }
    }
}
