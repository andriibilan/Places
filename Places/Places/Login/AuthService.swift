//
//  AuthService.swift
//  Places
//
//  Created by Yurii Vients on 11/26/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

struct AuthService {
    
    var dataBaseReference: DatabaseReference! {
        return Database.database().reference()
    }
    
    var storageReference: StorageReference! {
        return Storage.storage().reference()
    }
    
    func createUser(userName: String, email: String, phone: String, password: String,pictureData: Data!) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil {
                self.setUserInfo(userName: userName, email: email, phone: phone, password: password,pictureData: pictureData, user: user)
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func setUserInfo(userName: String, email: String, phone: String, password: String,pictureData: Data!, user: User!){
        
        let imagePath = NSUUID().uuidString
        
        let imageRef = storageReference.child(imagePath)
        
        let metaData = StorageMetadata()
        
        imageRef.putData(pictureData as Data, metadata: metaData) { (newMetaData, error) in
            
            if error == nil {
                
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = userName
                
                if let photoURL = newMetaData!.downloadURL() {
                    changeRequest.photoURL = photoURL
                }
                
                changeRequest.commitChanges(completion: { (error) in
                    if error == nil {
                        self.saveUserInfo(userName: userName, email: email, phone: phone, password: password, user: user)
                    } else {
                        print(error!.localizedDescription)
                    }
                })
            }
            else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func saveUserInfo(userName: String, email: String, phone: String, password: String, user: User) {
        
        let userInfo = ["userName": userName,
                        "email": email,
                        "phone": phone,
                        "password":password,
                        "photoURL": String(describing: user.photoURL!)]
        
        let userRef = dataBaseReference.child("Users").child(user.uid)
        
        userRef.setValue(userInfo) { (error, ref) in
            if error == nil {
                print("User info saved successfully")
                self.logIn(email: email, password: password)
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func updateUserInfo(userName: String, email: String, phone: String) {
        let userID : String = (Auth.auth().currentUser?.uid)!
        let currentUserInfo = ["userName": userName,
                               "email": email,
                               "phone": phone]
        //                               "photoURL": String(describing: userID.photoURL!)]
        
        let userRef = dataBaseReference.child("Users").child(userID)
        userRef.updateChildValues(currentUserInfo)
    }
    
    func logIn(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                print("You have successfully logged in")
                
                let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDel.showProfile()
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
}

