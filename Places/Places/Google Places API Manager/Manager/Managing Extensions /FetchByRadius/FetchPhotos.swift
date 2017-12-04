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
    func getPhotos(ofPlaceIndex placeIndex: Int?, ofPlace place: Place?, maxWidth: Int = 500, maxHeight: Int = 500, completion: @escaping (Place?, String?) -> ()){
        let index: Int
        
        if placeIndex != nil{
            index = placeIndex!
        } else if let givenPlace = place{
            if let indexOfGivenPlace = foundedPlaces.index(where: { $0.placeId ?? "empty" == givenPlace.placeId }) {
                index = indexOfGivenPlace
            } else { return }
        } else { return }
        
        
        let placeFromFoundedPlaces = foundedPlaces[index]
        
        func loadPhotos(of foundedPlace: Place?, errorMessage: String?){
            if foundedPlace == nil { return }
            if errorMessage != nil{
                completion(placeFromFoundedPlaces, errorMessage!)
                return
            }
            
            for photoReference in foundedPlace!.photoReferences{
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
                        
                        switch (response as! HTTPURLResponse).statusCode{
                        case 403:
                            completion(placeFromFoundedPlaces, "Photo gives: You have exceeded your daily request quota for this API")
                            return
                        case 400:
                            completion(placeFromFoundedPlaces, "Photo gives: Bad url request")
                            return
                        default: break
                        }
                        
                        if let dataImage = data{
                            if let image = UIImage(data: dataImage){
                                self?.foundedPlaces[index].photos.append(image)
                                
                                completion(self?.foundedPlaces[index], nil)
                            }
                        }
                        }.resume()
                }
            }
        }
        
        if placeFromFoundedPlaces.photoReferences.isEmpty{
            getAdditionalData(ofPlaceIndex: index, ofPlace: nil, completion: loadPhotos)
        } else{
            loadPhotos(of: placeFromFoundedPlaces, errorMessage: nil)
        }
    }
}
