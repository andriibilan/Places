//
//  LaunchScreenController.swift
//  Places
//
//  Created by Victoriia Rohozhyna on 12/5/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation
import UIKit

protocol SlashScreenHiddenDelegate: class {
    func splashScreenHidden()
}

class  LaunchScreenController: UIViewController {
    
    @IBOutlet weak var imageScreen: UIImageView!
    weak var delegate : SlashScreenHiddenDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        animationLogo()
    }

    func animationLogo() {
        
        UIView.animateKeyframes(withDuration: 1, delay: 0.25, options: [.autoreverse, .repeat], animations:  {
            UIView.setAnimationRepeatCount(3)
                         self.imageScreen.frame.origin.y += 0
            self.imageScreen.frame.origin.y += 20
            //            self.imageScreen.frame.origin.y = 0
            
        },completion: { finished in
//           self.view.removeFromSuperview()
            self.delegate?.splashScreenHidden()
        })
    }
}
