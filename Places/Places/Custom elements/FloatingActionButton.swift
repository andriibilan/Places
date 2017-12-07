//
//  FloatingActionButton.swift
//  Places
//
//  Created by Andrew Konchak on 11/21/17.
//  Copyright © 2017 Andrew Konchak. All rights reserved.
//

import UIKit

class FloatingActionButton: UIButtonExplicit {
    
    //MARK:- Rotate Menu Button
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
//        UIView.animate(withDuration: 0.3, animations: {
//            if self.transform == .identity {
//                self.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 180))
//                self.backgroundColor = #colorLiteral(red: 0.8338858485, green: 0.2595152557, blue: 0.3878593445, alpha: 1)
//            } else {
//                self.transform = .identity
//                self.backgroundColor = #colorLiteral(red: 0.9351765513, green: 0.296548903, blue: 0.4392450452, alpha: 1)
//            }
//        })
        
        return super.beginTracking(touch, with: event)
    }
}
