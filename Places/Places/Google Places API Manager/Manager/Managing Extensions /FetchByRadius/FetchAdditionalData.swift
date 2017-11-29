//
//  File.swift
//  Places
//
//  Created by Nazarii Melnyk on 11/29/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation
import UIKit

extension GooglePlacesManager{
    // MARK: - Fetching additional data
    
    /// Loads additional data for every Place in [Place]
    func getAdditionalData(of placeIndex: Int, completion: @escaping ([Place]?) -> Void){
        let placeId = foundedPlaces[placeIndex].placeId!
        
        // place detail request
        let jsonPlaceRequest = """
        https://maps.googleapis.com/maps/api/place/details/json?\
        placeid=\(placeId)&\
        key=\(apiKey)
        """
        print("\nParticular place request: " + jsonPlaceRequest)
        
        if let url = URL(string: jsonPlaceRequest){
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                if error != nil{
                    print("\n\tdataTask in \"getPhotos\": ")
                    print(error!)
                    return
                }
                
                do{
                    jsonPlaceRequest // used for debuging
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    let dictionary = json as! [String: Any]
                    if let place = dictionary["result"] as? [String: Any]{
                        self?.getPhoneNumber(of: place, forIndex: placeIndex)
                        self?.getAddress(of: place, forIndex: placeIndex)
                        self?.getWebsite(of: place, forIndex: placeIndex)
                        self?.getWorkingSchedule(of: place, forIndex: placeIndex)
                        self?.getPhotoReferences(of: place, forIndex: placeIndex)
                    }
                    self?.delegate?.loadedDataAt?(index: placeIndex, dataName: nil)
                    completion(self?.foundedPlaces)
                } catch let jsonError{
                    print("\n\tcatched in \"getAdditionalData\": ")
                    print(jsonError)
                }
                }.resume()
        }
    }
    /// Loads place phone number
    private func getPhoneNumber(of place: [String: Any], forIndex index: Int){
        if let internationalPhoneNumber = place["international_phone_number"] as? String{
            foundedPlaces[index].phoneNumber = internationalPhoneNumber
        }
    }
    /// Loads place address
    private func getAddress(of place: [String: Any], forIndex index: Int){
        if let address = place["formatted_address"] as? String{
            foundedPlaces[index].address = address
        }
    }
    /// Loads place website
    private func getWebsite(of place: [String: Any], forIndex index: Int){
        if let website = place["website"] as? String{
            foundedPlaces[index].website = website
        }
    }
    /// Loads place working schedule
    private func getWorkingSchedule(of place: [String: Any], forIndex index: Int){
        if let openingHours = place["opening_hours"] as? [String: Any]{
            if let weekdayText = openingHours["weekday_text"] as? [String]{
                foundedPlaces[index].workingSchedule = weekdayText
            }
        }
    }
    /// Loads place photo's references
    private func getPhotoReferences(of place: [String: Any], forIndex index: Int){
        if let photos = place["photos"] as? [[String: Any]]{
            for photo in photos{
                let photoReference = photo["photo_reference"] as! String
                
                foundedPlaces[index].photoReferences.append(photoReference)
            }
        }
    }
}
