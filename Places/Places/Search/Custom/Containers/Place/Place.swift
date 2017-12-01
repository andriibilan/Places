//
//  Place.swift
//  Places
//
//  Created by Nazarii Melnyk on 11/21/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import Foundation
import UIKit

class Place{
    var name: String? = nil
    var types = [PlaceType]()
    var isOpen: Bool? = nil
    var distance: Int? = nil
    var photo: UIImage? = nil
    var photos = [UIImage]()
    var location: Location? = nil
    var distanceFromLocation: Location? = nil
    var rating: Double? = nil
    var phoneNumber: String? = nil
    var placeId: String? = nil
    var address: String? = nil
    var website: String? = nil
    var icon: UIImage? = nil
    var workingSchedule: [String]? = nil
    var reviews = [Review]()
    
    var photoReferences = [String]()
}
