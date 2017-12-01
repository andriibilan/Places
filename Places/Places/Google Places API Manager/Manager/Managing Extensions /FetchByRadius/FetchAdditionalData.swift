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
    func getAdditionalData(ofPlaceIndex placeIndex: Int?, ofPlace place: Place?, completion: @escaping (Place?) -> ()){
        let placeId: String
        let index: Int
        
        if placeIndex != nil{
            placeId = foundedPlaces[placeIndex!].placeId!
            index = placeIndex!
        } else if let givenPlace = place{
            placeId = givenPlace.placeId!
            if let indexOfGivenPlace = foundedPlaces.index(where: { $0.placeId ?? "nil" == placeId }) {
                index = indexOfGivenPlace
            } else { return }
        } else { return }
        
        
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
                        self?.getPhoneNumber(of: place, forIndex: index)
                        self?.getAddress(of: place, forIndex: index)
                        self?.getWebsite(of: place, forIndex: index)
                        self?.getWorkingSchedule(of: place, forIndex: index)
                        self?.getPhotoReferences(of: place, forIndex: index)
                        self?.getReviews(of: place, forIndex: index)
                    }
                    completion(self?.foundedPlaces[index])
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
    /// Loads place reviews
    private func getReviews(of place: [String: Any], forIndex index: Int){
        if let reviews = place["reviews"] as? [[String: Any]]{
            for review in reviews{
                let fetchedReview = Review(
                    author: review["author_name"] as? String,
                    profilePhotoUrl: review["profile_photo_url"] as? String,
                    rating: review["rating"] as? Int,
                    text: review["text"] as? String
                )

                foundedPlaces[index].reviews.append(fetchedReview)
            }
        }
    }
    
}
