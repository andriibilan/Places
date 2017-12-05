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

    /// Loads additional data: phone number, address, website, working schedule, photo references(used for fetching photos in future), reviews
    func getAdditionalData(ofPlace givenPlace: Place, completion: @escaping (Place?, String?) -> ()){
        if let placeId = givenPlace.placeId{
            
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
                        
                        if let errorMessage = dictionary["error_message"] as? String{
                            completion(givenPlace, "Additional Data gives: " + errorMessage)
                            return
                        }
                        
                        if let place = dictionary["result"] as? [String: Any]{
                            self?.getPhoneNumber(of: place, saveTo: givenPlace)
                            self?.getAddress(of: place, saveTo: givenPlace)
                            self?.getWebsite(of: place, saveTo: givenPlace)
                            self?.getWorkingSchedule(of: place, saveTo: givenPlace)
                            self?.getPhotoReferences(of: place, saveTo: givenPlace)
                            self?.getReviews(of: place, saveTo: givenPlace)
                        }
                        if let indexOfGivenPlace = self?.foundedPlaces.index(where: { $0.placeId ?? "nil" == placeId }){
                            self?.foundedPlaces[indexOfGivenPlace] = givenPlace
                        }
                        completion(givenPlace, nil)
                    } catch let jsonError{
                        print("\n\tcatched in \"getAdditionalData\": ")
                        print(jsonError)
                    }
                    }.resume()
            }
        }
    }
    /// Loads place phone number
    private func getPhoneNumber(of place: [String: Any], saveTo givenPlace: Place){
        if let internationalPhoneNumber = place["international_phone_number"] as? String{
            givenPlace.phoneNumber = internationalPhoneNumber
        }
    }
    /// Loads place address
    private func getAddress(of place: [String: Any], saveTo givenPlace: Place){
        if let address = place["formatted_address"] as? String{
            givenPlace.address = address
        }
    }
    /// Loads place website
    private func getWebsite(of place: [String: Any], saveTo givenPlace: Place){
        if let website = place["website"] as? String{
            givenPlace.website = website
        }
    }
    /// Loads place working schedule
    private func getWorkingSchedule(of place: [String: Any], saveTo givenPlace: Place){
        if let openingHours = place["opening_hours"] as? [String: Any]{
            if let weekdayText = openingHours["weekday_text"] as? [String]{
                givenPlace.workingSchedule = weekdayText
            }
        }
    }
    /// Loads place photo's references
    private func getPhotoReferences(of place: [String: Any], saveTo givenPlace: Place){
        if let photos = place["photos"] as? [[String: Any]]{
            for photo in photos{
                let photoReference = photo["photo_reference"] as! String
                
                givenPlace.photoReferences.append(photoReference)
            }
        }
    }
    /// Loads place reviews
    private func getReviews(of place: [String: Any], saveTo givenPlace: Place){
        if let reviews = place["reviews"] as? [[String: Any]]{
            for review in reviews{
                let fetchedReview = Review(
                    author: review["author_name"] as? String,
                    profilePhotoUrl: review["profile_photo_url"] as? String,
                    rating: review["rating"] as? Int,
                    text: review["text"] as? String
                )

                givenPlace.reviews.append(fetchedReview)
            }
        }
    }
    
}
