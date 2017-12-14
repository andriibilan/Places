//
//  ExtensionListViewTransitioningDelegate.swift
//  Places
//
//  Created by Andrii Antoniak on 12/14/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation
import UIKit

extension ListViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        // transition.startingPoint = dismissButton.center
        transition.startingPoint = CGPoint(x: view.bounds.maxX / 2, y: view.bounds.maxY - (view.bounds.maxY * 0.1 / 2))
        transition.circleColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = CGPoint(x: view.bounds.maxX / 2, y: view.bounds.maxY - (view.bounds.maxY * 0.1 / 2))
        transition.circleColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return transition
    }
}
