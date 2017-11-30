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
    func fetchPlaces(completion: @escaping ([Place]?) -> ()){
        foundedPlaces.removeAll()
        allPlacesLoaded = false
        loadedPlaceTypes = 0
        
        let jsonPlacesInRadiusRequest = """
        https://maps.googleapis.com/maps/api/place/nearbysearch/json?\
        location=\(currentLocation.latitude),\(currentLocation.longitude)&\
        radius=\(radius)&
        """
        
        for filter in filters{
            let requestForCertainType = jsonPlacesInRadiusRequest +
            "type=\(filter.rawValue)&" +
            "key=\(apiKey)"
            
            print("\nPlaces in Radius: " + requestForCertainType)
            
            if let url = URL(string: requestForCertainType){
                getBasicData(from: url, completion: completion)
            } else{
                print("\nerror converting json \"Places in Radius\" request to URL")
            }
        }
    }
    
    
    // MARK: - Fetching basic data
    
    /// Loads basic data values (by nearbysearch request): name, openingStatus, location, icon, placeId, types, rating, photo
    private func getBasicData(from url: URL, completion: @escaping ([Place]?) -> ()){
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if error != nil{
                print("\n\tdataTask in \"fetchPlaces\": ")
                print(error!)
                return
            }
            if self == nil {return}
            
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let dictionary = json as! [String: Any]
                let results = dictionary["results"] as! [[String: Any]]
                
                addingNewPlace:
                    for place in results{
                        
                        for existingPlace in (self?.foundedPlaces)!{
                            if self?.getPlaceId(of: place) == existingPlace.placeId{
                                continue addingNewPlace
                            }
                        }
                        
                        self?.foundedPlaces.append(Place())
                        
                        let lastPlaceIndex = (self?.foundedPlaces.count)! - 1
                        
                        self?.getName(of: place, forPlaceIndex: lastPlaceIndex)
                        self?.getOpeningStatus(of: place, forPlaceIndex: lastPlaceIndex)
                        self?.getLocation(of: place, forIndex: lastPlaceIndex)
                        self?.getIcon(of: place, forIndex: lastPlaceIndex)
                        self?.getPlaceId(of: place, forIndex: lastPlaceIndex)
                        // need to think about api of "getTypes"
						self?.getTypes(of: place, forIndex: lastPlaceIndex)
                        self?.getRating(of: place, forIndex: lastPlaceIndex)
                        self?.getStraightDistance(to: lastPlaceIndex)
                }
                self?.loadedPlaceTypes += 1
                self?.allPlacesLoaded = self?.loadedPlaceTypes == self?.filters.count
                
                completion(self?.foundedPlaces)
            } catch let jsonError{
                print("\n\tcatched in \"fetchPlaces\": ")
                print(jsonError)
            }
            }.resume()
    }
    /// Returns place "place_id" to check is place already exists
    private func getPlaceId(of place: [String: Any]) -> String{
        return place["place_id"] as! String
    }
    /// Loads place name
    private func getName(of place: [String: Any], forPlaceIndex index: Int){
        if let name = place["name"] as? String{
            foundedPlaces[index].name = name
        }
    }
    /// Loads place opening status (eather is open or not)
    private func getOpeningStatus(of place: [String: Any], forPlaceIndex index: Int){
        if let openInfo = place["opening_hours"] as? [String: Any]{
            if let isOpen = openInfo["open_now"] as? Bool{
                foundedPlaces[index].isOpen = isOpen
            }
        }
    }
    /// Loads place location
    private func getLocation(of place: [String: Any], forIndex index: Int){
        if let geometry = place["geometry"] as? [String: Any]{
            if let jsonLocation = geometry["location"] as? [String: Double]{
                let latitude = jsonLocation["lat"]!
                let longitude = jsonLocation["lng"]!
                let placeLocation = Location(latitude: latitude, longitude: longitude)
                
                foundedPlaces[index].location = placeLocation
            }
        }
    }
    /// Loads place icon
    private func getIcon(of place: [String: Any], forIndex index: Int){
        if let iconReference = place["icon"] as? String{
			foundedPlaces[index].photoReferences = [iconReference]
            if let url = URL(string: iconReference){
                if let data = try? Data(contentsOf: url){
                    foundedPlaces[index].icon = UIImage(data: data)
                }
            }
        }
    }
    /// Loads place place_id
    private func getPlaceId(of place: [String: Any], forIndex index: Int){
        if let placeId = place["place_id"] as? String{
            foundedPlaces[index].placeId = placeId
        }
    }
    /// Loads place types
    private func getTypes(of place: [String: Any], forIndex index: Int){
        if let types = place["types"] as? [String]{
            for type in types{
                if let typeAsEnum = PlaceType(rawValue: type){
                    foundedPlaces[index].types.append(typeAsEnum)
                }
            }
        }
    }
    /// Loads place rating
    private func getRating(of place: [String: Any], forIndex index: Int){
        if let rating = place["rating"] as? Double{
            foundedPlaces[index].rating = rating
        }
    }
    /// Calculates distance between two point
    private func getStraightDistance(to placeIndex: Int){
        let origin = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        
        if let destination = foundedPlaces[placeIndex].location{
            let placeLocation = CLLocation(latitude: destination.latitude, longitude: destination.longitude)
            
            foundedPlaces[placeIndex].distance = Int(placeLocation.distance(from: origin))
            foundedPlaces[placeIndex].distanceFromLocation = currentLocation
        }
    }
    /// Loads place photo (only 1)
    private func getPhoto(of place: [String: Any], forIndex index: Int, completion: @escaping (Place?) -> ()){
        if let photos = place["photos"] as? [[String: Any]]{
            if !photos.isEmpty{
                if let photoReference = photos[0]["photo_reference"] as? String{
                    let maxwidth = 500, maxheight = 500
                    let jsonPhotoRequest = """
                    https://maps.googleapis.com/maps/api/place/photo?\
                    maxwidth=\(maxwidth)&\
                    maxheight=\(maxheight)&\
                    photoreference=\(photoReference)&\
                    key=\(apiKey)
                    """
                    if let url = URL(string: jsonPhotoRequest){
                        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                            if error != nil{
                                print("\n\tdataTask in \"get image from getPhotos\": ")
                                print(error!)
                                return
                            }
                            if self == nil {return}
                            
                            print("\nPhotoRequest: " + jsonPhotoRequest)
                            
                            if let dataImage = data{
                                if let image = UIImage(data: dataImage){
                                    self?.foundedPlaces[index].photo = image
                                    
                                    completion(self?.foundedPlaces[index])
                                }
                            }
                            }.resume()
                    }
                }
            }
        }
    }
}
