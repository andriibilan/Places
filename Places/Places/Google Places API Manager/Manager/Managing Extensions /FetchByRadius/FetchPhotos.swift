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
    /// Loads place photos (up to 10); (by details request)
    func getPhotos(of placeIndex: Int, maxWidth: Int = 500, maxHeight: Int = 500){
        let place = foundedPlaces[placeIndex]
        
        for photoReference in place.photoReferences{
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
                    if self == nil {return}
                    
                    print("\nPhotoRequest: " + jsonPhotoRequest)
                    
                    if let dataImage = data{
                        if let image = UIImage(data: dataImage){
                            self?.foundedPlaces[placeIndex].photos.append(image)
                            
                            self?.delegate?.loadedDataAt?(index: placeIndex, dataName: "photos")
//                            self?.updateUI?((self?.foundedPlaces)!, placeIndex, "photos")
                        }
                    }
                    }.resume()
            }
        }
    }
}
