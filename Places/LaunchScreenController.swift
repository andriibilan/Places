//
//  LaunchScreenController.swift
//  Places
//
//  Created by Victoriia Rohozhyna on 12/5/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation
import UIKit

class  LaunchScreenController: UIViewController {
    
    @IBOutlet weak var imageScreen: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        animationLogo()
    }

    func animationLogo() {
        
        UIView.animateKeyframes(withDuration: 1, delay: 0.25, options: [.autoreverse, .repeat], animations:  {
//            UIView.setAnimationRepeatCount(5)
//            self.imageScreen.frame.origin.y += 0
            self.imageScreen.frame.origin.y += 20
        })
//            ,completion: { finished in
//           self.view.removeFromSuperview()
//            self.delegate?.splashScreenHidden()
//        })
    }
}
