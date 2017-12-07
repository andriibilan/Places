//
//  SlideMenuActionButton.swift
//  Places
//
//  Created by Andrew Konchak on 11/21/17.
//  Copyright © 2017 Andrew Konchak. All rights reserved.
//

import UIKit

class SlideMenuActionButton: UIButtonExplicit {

    // MARK:- Rotate Filter Button
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {

        UIView.animate(withDuration: 0.3, animations: {
            if self.transform == .identity {
                self.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 180))
                self.backgroundColor = #colorLiteral(red: 0.2274509804, green: 0.6784313725, blue: 0.5490196078, alpha: 1)
            } else {
                self.transform = .identity
                self.backgroundColor = #colorLiteral(red: 0.2274509804, green: 0.6784313725, blue: 0.5490196078, alpha: 1)
            }
        })

        return super.beginTracking(touch, with: event)
    }
}

