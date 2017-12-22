//
//  AppDelegate.swift
//  Places
//
//  Created by andriibilan on 11/22/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    
    static var apiKey = "AIzaSyB-pH6swhtcKVc0GzzL0pOTIr8Z9c36WoU"

    //static var apiKey = ""
    
    //AIzaSyB1AHQpRBMU2vc6T7guiqFz2f5_CUyTRRc
    //AIzaSyDLxIv8iHmwytbkXR5Gs2U9rqoLixhXIXM
    //AIzaSyCVaciTxny1MNyP9r38AelJu6Qoj2ImHF0
    //AIzaSyC-bJQ22eXNhviJ9nmF_aQ0FSNWK2mNlVQ
    //AIzaSyAQds9vi_5uYPsprEO58LHlM8a_u2OQgIE
    //AIzaSyAJWZdkxoRmSEMpmgTQJIsP5AEk-imEniY
    //AIzaSyD1EzRFmZpAKq5KZzcFYOwDL8_YfllCeAo
    //AIzaSyCOrfXohc5LOn-J6aZQHqXc0nmsYEhAxQQ
    //AIzaSyB-pH6swhtcKVc0GzzL0pOTIr8Z9c36WoU
    //AIzaSyAEMsUJkEQaNxAxcmuQ92dnjQOWtEz1A_g
    //AIzaSyB1stl48ZyTMr4Y6Su7nKHs5a0pLzoVe5w
    //AIzaSyAEMsUJkEQaNxAxcmuQ92dnjQOWtEz1A_g


    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        
        return handled
    }
 
}
