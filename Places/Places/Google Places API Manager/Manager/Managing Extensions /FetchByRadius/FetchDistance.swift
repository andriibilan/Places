//
//  FetchDistance.swift
//  Places
//
//  Created by Nazarii Melnyk on 11/29/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation
import UIKit

extension GooglePlacesManager{
    /// Loads distance from "currentLocation" to place location (by distancematrix request)
    func getRealDistance(to placeIndex: Int){
        if let destination = foundedPlaces[placeIndex].location{
            let origin = currentLocation
            
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
                URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                    if error != nil{
                        print("\n\tdataTask in \"getDistance\": ")
                        print(error!)
                        return
                    }
                    if self == nil {return}
                    
                    do{
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                        if let dictionary = json as? [String: Any]{
                            if let rows = dictionary["rows"] as? [[String: Any]]{
                                if !rows.isEmpty{
                                    let elements = rows[0]["elements"] as! [[String: Any]]
                                    let element = elements[0]
                                    let distance = element["distance"] as! [String: Any]
                                    let distanceValue = distance["value"] as! Int
                                    
                                    self?.foundedPlaces[placeIndex].distance = distanceValue
                                    self?.foundedPlaces[placeIndex].distanceFromLocation = self?.currentLocation
                                    
                                    self?.delegate?.loadedAllPlaces?()
                                    // need to resolve it
                                    //                                    self?.delegate?.loadedDataAt(index: placeIndex, dataName: "distance")
//                                    self?.updateUI?((self?.foundedPlaces)!, placeIndex, "distance")
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
    }
}
