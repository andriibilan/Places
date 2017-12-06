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
    

    static var apiKey = "AIzaSyAEMsUJkEQaNxAxcmuQ92dnjQOWtEz1A_g"
//        AIzaSyB1AHQpRBMU2vc6T7guiqFz2f5_CUyTRRc
//        AIzaSyDLxIv8iHmwytbkXR5Gs2U9rqoLixhXIXM
//        AIzaSyCVaciTxny1MNyP9r38AelJu6Qoj2ImHF0
//        AIzaSyC-bJQ22eXNhviJ9nmF_aQ0FSNWK2mNlVQ
//        AIzaSyAQds9vi_5uYPsprEO58LHlM8a_u2OQgIE
//        AIzaSyAJWZdkxoRmSEMpmgTQJIsP5AEk-imEniY
//        AIzaSyD1EzRFmZpAKq5KZzcFYOwDL8_YfllCeAo
//        AIzaSyCOrfXohc5LOn-J6aZQHqXc0nmsYEhAxQQ
//    AIzaSyAEMsUJkEQaNxAxcmuQ92dnjQOWtEz1A_g
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        
        return handled
    }
    
//    func showProfile(){
//        
//        if Auth.auth().currentUser != nil {
//            let profileVC = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
//            self.window?.rootViewController = profileVC
//        } else {
//            let profileVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
//            self.window?.rootViewController = profileVC
//        }
//    }
}
