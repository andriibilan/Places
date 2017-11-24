//
//  SearchManager.swift
//  Places
//
//  Created by Nazarii Melnyk on 11/23/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import Foundation
import UIKit

class SearchManager{
    var delegate: SearchManagerDelegate?
    
    var apiKey: String = "none"
    var radius: Int = 100.m
    var currentLocation = Location.currentLocation()
    
    var foundedPlaces = [Place]()
//    private var filledDistancesOfPlaces = 0
//    private var filledPhotosOfPlaces = 0
    
    init(apiKey: String, radius: Int, currentLocation: Location, delegate: SearchManagerDelegate?) {
        self.apiKey = apiKey
        self.radius = radius
        self.currentLocation = currentLocation
        self.delegate = delegate
        
        fetchPlaces()
    }
    
    /// Returns all places in given radius
    func fetchPlaces(){
        foundedPlaces.removeAll()
//        filledDistancesOfPlaces = 0
//        filledPhotosOfPlaces = 0
        
        let jsonPlacesInRadiusRequest = """
        https://maps.googleapis.com/maps/api/place/nearbysearch/json?\
        location=\(currentLocation.latitude),\(currentLocation.longitude)&\
        radius=\(radius)&\
        key=\(apiKey)
        """
        print("\nPlaces in Radius: " + jsonPlacesInRadiusRequest)
        
        if let url = URL(string: jsonPlacesInRadiusRequest){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    print("\n\tdataTask in \"fetchPlaces\": ")
                    print(error!)
                    return
                }
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    let dictionary = json as! [String: Any]
                    let results = dictionary["results"] as! [[String: Any]]
                    
                    for place in results{
                        var placeInfo = Place()
                        
                        if let name = place["name"] as? String{
                            placeInfo.name = name
                        }
                        
                        if let openInfo = place["opening_hours"] as? [String: Bool]{
                            if let isOpen = openInfo["open_now"]{
                                placeInfo.isOpen = isOpen
                            }
                        }
                        self.foundedPlaces.append(placeInfo)
                        
                        // executing closures
                        if let placeLocation = self.getLocation(of: place){
                            self.getDistance(from: self.currentLocation, to: placeLocation, forIndex: self.foundedPlaces.count - 1)
                        }
                        self.getPhotos(of: place, forIndex: self.foundedPlaces.count - 1)
                    }
                    
                    self.delegate?.reloadAllData()
                } catch let jsonError{
                    print("\n\tcatched in \"fetchPlaces\": ")
                    print(jsonError)
                }
                }.resume()
        } else{
            print("\nerror converting json \"Places in Radius\" request to URL")
        }
    }
    
    /// Returns location of given place
    private func getLocation(of place: [String: Any]) -> Location?{
        if let geometry = place["geometry"] as? [String: Any]{
            if let jsonLocation = geometry["location"] as? [String: Double]{
                let latitude = jsonLocation["lat"]!
                let longitude = jsonLocation["lng"]!
                
                return Location(latitude: latitude, longitude: longitude)
            }
        }
        return nil
    }
    
    /// Returns distance from one point to another in meters
    private func getDistance(from origin: Location, to destination: Location, forIndex index: Int){
        let mode = "walking"
        let jsonDistanceRequest = """
        https://maps.googleapis.com/maps/api/distancematrix/json?\
        origins=\(origin.latitude),\(origin.longitude)&\
        destinations=\(destination.latitude),\(destination.longitude)&\
        mode=\(mode)&\
        key=\(apiKey)
        """
        print("\nDistance Request: " + jsonDistanceRequest)
        
        if let url = URL(string: jsonDistanceRequest){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
//                self.filledDistancesOfPlaces += 1
                
                if error != nil{
                    print("\n\tdataTask in \"getDistance\": ")
                    print(error!)
                    return
                }
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    if let dictionary = json as? [String: Any]{
                        if let rows = dictionary["rows"] as? [[String: Any]]{
                            if !rows.isEmpty{
                                let elements = rows[0]["elements"] as! [[String: Any]]
                                let element = elements[0]
                                let distance = element["distance"] as! [String: Any]
                                let distanceValue = distance["value"] as! Int
                                
                                self.foundedPlaces[index].distance = distanceValue
                                
                                self.delegate?.reloadRowAt(index: index)
                            }
                        }
                    }
                } catch let jsonError{
                    print("\n\tcatched in \"getDistance\": ")
                    print(jsonError)
                }
                }.resume()
        } else{
            print("\nerror converting json \"Distance\" request to URL")
        }
    }
    
    /// Returns array of place photos
    private func getPhotos(of place: [String: Any], forIndex index: Int){
        let placeId = place["place_id"] as! String
        
        // place info
        let jsonPlaceRequest = """
        https://maps.googleapis.com/maps/api/place/details/json?\
        placeid=\(placeId)&\
        key=\(apiKey)
        """
        print("\nParticular place request: " + jsonPlaceRequest)
        
        if let url = URL(string: jsonPlaceRequest){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
//                self.filledPhotosOfPlaces += 1
                
                if error != nil{
                    print("\n\tdataTask in \"getPhotos\": ")
                    print(error!)
                    return
                }
                
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    let dictionary = json as! [String: Any]
                    if let result = dictionary["result"] as? [String: Any]{
                        if let photos = result["photos"] as? [[String: Any]]{
                            for photo in photos{
                                let photoReference = photo["photo_reference"] as! String
                                let maxwidth = 500, maxheight = 500
                                
                                let jsonPhotoRequest = """
                                https://maps.googleapis.com/maps/api/place/photo?\
                                maxwidth=\(maxwidth)&\
                                maxheight=\(maxheight)&\
                                photoreference=\(photoReference)&\
                                key=\(self.apiKey)
                                """
                                //                            print(jsonPhotoRequest)
                                
                                if let url = URL(string: jsonPhotoRequest){
                                    if let data = try? Data(contentsOf: url){
                                        if let image = UIImage(data: data){
                                            self.foundedPlaces[index].photos.append(image)
                                        }
                                    }
                                }
                            }
                            self.delegate?.reloadRowAt(index: index)
                        }
                    }
                } catch let jsonError{
                    print("\n\tcatched in \"getPhotos\": ")
                    print(jsonError)
                }
                }.resume()
        } else{
            print("\nerror converting json \"Particular place\" request to URL")
        }
    }
}
