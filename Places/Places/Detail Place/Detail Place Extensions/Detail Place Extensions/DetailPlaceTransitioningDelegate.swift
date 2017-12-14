//
//  DetailPlaceTransitioningDelegate.swift
//  Places
//
//  Created by Andrii Antoniak on 12/14/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation
import UIKit

extension DetailPlaceViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        // transition.startingPoint = dismissButton.center
        transition.startingPoint = CGPoint(x: view.bounds.maxX - 50, y: view.bounds.maxY - 50)
        transition.circleColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = CGPoint(x: view.bounds.maxX - 50, y: view.bounds.maxY - 50)
        transition.circleColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return transition
    }
}
