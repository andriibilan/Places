//
//  TestModelPlace.swift
//  Places
//
//  Created by Andrii Antoniak on 11/24/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation
import UIKit



class Review{
    var reviewer : String?
    var review : String?
    var isanonymous : Bool!
    var reviewRatting : Double?
    
    init(){
        reviewer = "Reviewer"
        review = """
        1234567890 1234567890 12345678901234567890 1234567890 12345678901234567890 1234567890 12345678901234567890 1234567890 12345678901234567890 1234567890 12345678901234567890 1234567890 12345678901234567890 12345678900 12345678901234567890 1234567890 12345678901234567890 1234567890 12345678901234567890 1234567890 12345678901234567890 1234567890 123456789012345678900 12345678901234567890 1234567890 12345678901234567890 1234567890 12345678901234567890 1234567890 12345678901234567890 1234567890 123456789012345678900 12345678901234567890 1234567890 12345678901234567890 1234567890 12345678901234567890 1234567890 12345678901234567890 1234567890 12345678901234567890
        """
        
        isanonymous = false
        reviewRatting = 2.3
    }
    
    init(_ : Int){
        reviewer = "Reviewer"
        review = """
        1234567890 1234567890 1234567890
        1234567890 1234567890 1234567890
        1234567890 1234567890 1234567890
        1234567890 1234567890 1234567890
        """
        
        isanonymous = true
        reviewRatting = 4.7
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
    var forReview : [Review] = []
    
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
        forReview.append(Review(4))
        forReview.append(Review())
        forReview.append(Review(4))
        forReview.append(Review())
        forReview.append(Review(4))
        forReview.append(Review())
        forReview.append(Review(4))
        forReview.append(Review())
    }
    
    
    
    
    
    
    
}
