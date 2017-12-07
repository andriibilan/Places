//
//  User.swift
//  Places
//
//  Created by Yurii Vients on 11/24/17.
//  Created by Yurii Vients on 11/26/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation
import Firebase

class Users {
    var firstName: String?
    var email: String?
    var phone: String?
    var password: String?
    var ImageUrl: String?
    
    init(name: String, email: String, phone: String, ImageUrl: String) {
        
        self.firstName = name
        self.email = email
        self.phone = phone
        self.ImageUrl = ImageUrl
    }
    
    init(snapshot: DataSnapshot) {
        
        let value = snapshot.value as! NSDictionary
        
        self.firstName = value["userName"] as? String
        self.email = value["email"] as? String ?? ""
        self.password = value["password"] as? String ?? ""
        self.phone = value["phone"] as? String ?? ""
        self.ImageUrl = value["photoURL"] as? String ?? ""
    }
}

