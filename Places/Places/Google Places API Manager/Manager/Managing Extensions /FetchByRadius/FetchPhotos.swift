//
//  FetchPhotos.swift
//  Places
//
//  Created by Nazarii Melnyk on 11/29/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation
import UIKit

extension GooglePlacesManager{
    /// Loads place photos (up to 10); (by photo requests)
    func getPhotos(ofPlace givenPlace: Place, maxWidth: Int = 500, maxHeight: Int = 500, completion: @escaping (Place?, String?) -> ()){

        func loadPhotos(of foundedPlace: Place?, errorMessage: String?) {
            if foundedPlace == nil { return }
            if errorMessage != nil {
                completion(givenPlace, errorMessage!)
                return
            }
            
            loadedPlaceTypes = 0
            
            for photoReference in foundedPlace!.photoReferences {
                if photoReference.hasPrefix("http") {
                    if photoReference.count == 1 {
                        completion(givenPlace, nil)
                    }
                    continue
                }
                
                let jsonPhotoRequest = """
                https://maps.googleapis.com/maps/api/place/photo?\
                maxwidth=\(maxWidth)&\
                maxheight=\(maxHeight)&\
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
                        print("\nPhotoRequest: " + jsonPhotoRequest)
                        
                        switch (response as! HTTPURLResponse).statusCode {
                        case 403:
                            completion(givenPlace, "Photo gives: You have exceeded your daily request quota for this API")
                            return
                        case 400:
                            completion(givenPlace, "Photo gives: Bad url request")
                            return
                        default: break
                        }
                        
                        if let dataImage = data{
                            if let image = UIImage(data: dataImage) {
                                givenPlace.photos.append(image)
                                
                                self?.loadedPhotos += 1
                                
                                // if all photos loaded
                                if (self?.loadedPhotos) == (givenPlace.photoReferences.count - 1) {
                                    completion(givenPlace, nil)
                                }
                            }
                        }
                        }.resume()
                }
            }
            if let indexOfGivenPlace = foundedPlaces.index(where: { $0.placeId ?? "empty" == givenPlace.placeId }) {
                foundedPlaces[indexOfGivenPlace] = givenPlace
            }
        }
        
        self.loadedPhotos = 0
        
        if givenPlace.reviews.isEmpty {  // "review" instead of "photoReferences" because "photoReferences" has icon!
            getAdditionalData(ofPlace: givenPlace, completion: loadPhotos)
        } else {
            loadPhotos(of: givenPlace, errorMessage: nil)
        }
    }
}
