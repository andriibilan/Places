//
//  Dynamic.swift
//  Places
//
//  Created by andriibilan on 11/30/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import  UIKit

class Dynamic {
    var animator: UIDynamicAnimator?
    var panGesture: UIPanGestureRecognizer?
    var snap: UISnapBehavior?
    var snapCompass: UISnapBehavior?
    var snapMenu: UISnapBehavior?
    
    var box: UIButton?
    var compass: UIButton?
    var segmentD: UISegmentedControl?
    
    var parentView: UIView?
    var mainView: UIView?
    var originalCenter: CGPoint?
    var originalCenterCompass: CGPoint?
    var originalCenterMenu: CGPoint?
    

    func dynamicFilter (button: UIButton, parView: UIView) {
        box = button
        parentView = parView
        animator = UIDynamicAnimator(referenceView: parentView!)
        originalCenter = box?.center
        print("centerCompass: \(String(describing: originalCenterCompass))")
        snap = UISnapBehavior(item: box!, snapTo: originalCenter!)
        print("center filter \(String(describing: originalCenter))" )
        
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(panning))
        self.box?.addGestureRecognizer(panGesture!)
    }
 //   CGPoint(x: (self.greenBox?.bounds.midX)!, y: (self.greenBox?.bounds.midY)!)
    func dynamicCompass (button: UIButton, parView: UIView) {
        compass = button
        parentView = parView
        animator = UIDynamicAnimator(referenceView: parentView!)
        //let  compasCenter = CGPoint(x: (compass?.bounds.origin.x)! + (compass?.bounds.size.width)!/2,  y: (compass?.bounds.origin.y)! + (compass?.bounds.size.height)!/2)
        //originalCenterCompass = compass?.convert(compasCenter, to: parentView)
       // originalCenterCompass = compass?.bounds
        originalCenterCompass = compass?.center
        snapCompass = UISnapBehavior(item: compass!, snapTo: originalCenterCompass!)
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(panCompass))
        self.compass?.addGestureRecognizer(panGesture!)
        print("center Compass \(String(describing: originalCenterCompass))")
    }
    
    
    func dynamicSegment (segment: UISegmentedControl, parView: UIView) {
        segmentD = segment
        mainView = parView
        animator = UIDynamicAnimator(referenceView: mainView!)
        originalCenterMenu = segmentD?.center
        snapMenu = UISnapBehavior(item: segmentD!, snapTo: originalCenterMenu!)
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(panMenu))
        self.segmentD?.addGestureRecognizer(panGesture!)
        
        
    }
    
//    func animation(button: UIButton) {
//        UIView.animate(withDuration: 0.3, animations: {
//            if button.transform == .identity {
//                button.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 180))
//                button.backgroundColor = #colorLiteral(red: 0.2274509804, green: 0.6784313725, blue: 0.5490196078, alpha: 1)
//            } else {
//                button.transform = .identity
//                button.backgroundColor = #colorLiteral(red: 0.2274509804, green: 0.6784313725, blue: 0.5490196078, alpha: 1)
//            }
//        })
//        
//    }
    
    @objc func panning(pan: UIPanGestureRecognizer) {
        self.animator!.removeAllBehaviors()
        switch pan.state {
        case .began:
            box?.center = pan.location(ofTouch: 0, in: parentView)
        case .changed:
            box?.center = pan.location(ofTouch: 0, in: parentView)
        case .ended:
            self.animator!.addBehavior(self.snap!)
        default:
            break
        }
    }
    
    @objc func panCompass(pan: UIPanGestureRecognizer) {
        self.animator!.removeAllBehaviors()
        switch pan.state {
        case .began:
            compass?.center = pan.location(ofTouch: 0, in: parentView)
        case .changed:
            compass?.center = pan.location(ofTouch: 0, in: parentView)
        case .ended:
            self.animator!.addBehavior(self.snapCompass!)
        default:
            break
        }
    }
    @objc func panMenu(pan: UIPanGestureRecognizer) {
        self.animator!.removeAllBehaviors()
        switch pan.state {
        case .began:
            segmentD?.center = pan.location(ofTouch: 0, in: mainView)
        case .changed:
            segmentD?.center = pan.location(ofTouch: 0, in: mainView)
        case .ended:
            self.animator!.addBehavior(self.snapMenu!)
        default:
            break
        }
    }
}
