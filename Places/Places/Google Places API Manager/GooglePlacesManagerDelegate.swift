//
//  GooglePlacesManagerDelegate.swift
//  Places
//
//  Created by Nazarii Melnyk on 11/23/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import Foundation

@objc protocol GooglePlacesManagerDelegate{
    /// Notificates when "foundPlaces" array is filled by "Places" objects (but not all data in these objects)
    @objc optional func loadedAllPlaces()
    /// Notificates when some parameter - "dataName" argument - is filled in certain "Place" (passed by "index" argument)
    @objc optional func loadedDataAt(index: Int, dataName: String?)
}
