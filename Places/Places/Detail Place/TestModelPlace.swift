//
//  TestModelPlace.swift
//  Places
//
//  Created by Andrii Antoniak on 11/24/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation
import UIKit



class ReviewTest{
    var reviewer : String?
    var review : String?
    var isanonymous : Bool!
    var reviewRatting : Double?
    
    init(){
        reviewer = "Reviewer"
        review = """
        1234567890 1234567890 1234567890 
        1234567890 1234567890 1234567890
        1234567890 1234567890 1234567890
        1234567890 1234567890 1234567890
        1234567890 1234567890 1234567890
        1234567890 1234567890 1234567890
        1234567890 1234567890 1234567890
        1234567890 1234567890 1234567890
        """
        
        isanonymous = false
        reviewRatting = 3.2
    }
}

class TestPlace{
    
    var image : [UIImage] = []
    var name : String?
    var address : String?
    var ratting : Double?
    var website : String?
    var hours : String?
    var phone : String?
    //
    var forReview : [ReviewTest] = []
    
    func installDefaultValues(){
        //
        image.append(#imageLiteral(resourceName: "noPhotoIcon"))
        image.append(#imageLiteral(resourceName: "phone number"))
        image.append(#imageLiteral(resourceName: "path"))
        image.append(#imageLiteral(resourceName: "ratting"))
        image.append(#imageLiteral(resourceName: "website"))
        image.append(#imageLiteral(resourceName: "share"))
        image.append(#imageLiteral(resourceName: "address"))
        image.append(#imageLiteral(resourceName: "opening hours"))
        image.append(#imageLiteral(resourceName: "path"))
        image.append(#imageLiteral(resourceName: "ratting"))
        image.append(#imageLiteral(resourceName: "phone number"))
        image.append(#imageLiteral(resourceName: "website"))
        //
        name = "Cafe"
        address = "Pasternaka Street"
        ratting = 3.712
        website = "football.ua"
        hours = "Today"
        phone = "380925839548"
        //
        //TODO: Review!!!
        forReview.append(ReviewTest())
        forReview.append(ReviewTest())
        forReview.append(ReviewTest())
        forReview.append(ReviewTest())
    }
    
    
    
    
    
    
    
}
