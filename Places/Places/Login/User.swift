//
//  User.swift
//  Places
//
//  Created by Yurii Vients on 11/26/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation
import Firebase

class Users {
    var firstName: String?
    var lastName: String?
    var email: String?
    var phone: String?
    var password: String?
    var ImageUrl: String?
    
    
    init(snapshot: DataSnapshot) {
        
        let value = snapshot.value as! NSDictionary
        
        self.firstName = value["firstName"] as? String
        self.email = value["email"] as? String ?? ""
        self.password = value["password"] as? String ?? ""
        self.phone = value["phone"] as? String ?? ""
        self.ImageUrl = value["photoURL"] as? String ?? ""
    }
}


