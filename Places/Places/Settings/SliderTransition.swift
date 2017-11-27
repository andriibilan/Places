//
//  SliderTransition.swift
//  Places
//
//  Created by andriibilan on 11/26/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class SliderTransition: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
  let duration = 0.5
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        
        let container = transitionContext.containerView
        let screenOffUP = CGAffineTransform(translationX: 0, y: -container.frame.height)
        let screenOffDown = CGAffineTransform(translationX: 0, y: container.frame.height)
        
        container.addSubview(fromView)
        container.addSubview(toView)
        toView.transform = screenOffUP
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            fromView.transform = screenOffDown
            fromView.alpha = 0.5
            toView.transform = CGAffineTransform.identity
            toView.alpha = 1
            
            
        }) { (success) in
            transitionContext.completeTransition(success)
        }
    }
    

    
    
}
