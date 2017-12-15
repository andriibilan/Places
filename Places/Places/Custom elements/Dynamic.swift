//
//  Dynamic.swift
//  Places
//
//  Created by andriibilan on 11/30/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import  UIKit
import QuartzCore

class Dynamic {
    var animator: UIDynamicAnimator?
    var panGesture: UIPanGestureRecognizer?
    
    var snap: UISnapBehavior?
    var snapFilter: UISnapBehavior?
    var snapSort: UISnapBehavior?
    
    var box: UIButton?
    var filterD: UIButton?
    var sort: UIButton?
 
    var parentView: UIView?
    var listView: UIView?
    
    func dynamicFilter (button: UIButton, parView: UIView) {
        box = button
        parentView = parView
        animator = UIDynamicAnimator(referenceView: parentView!)
        let snapToNewCoordFilter = CGPoint(x:  (box?.frame.origin.x)! + (box?.frame.width)!/2 , y: (parentView?.frame.maxY)! - 50 )
        snap = UISnapBehavior(item: box!, snapTo: snapToNewCoordFilter)
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(panning))
        self.box?.addGestureRecognizer(panGesture!)
    }
    
    func dynamicSort (button: UIButton, parView: UIView) {
        sort = button
        listView = parView
        animator = UIDynamicAnimator(referenceView: listView!)
        let snapToNewCoordMenu = CGPoint(x: (sort?.frame.origin.x)! + (sort?.frame.width)!/2 , y: (listView?.frame.maxY)! - 50 )
        snapSort = UISnapBehavior(item: sort!, snapTo: snapToNewCoordMenu)
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(panSort))
        self.sort?.addGestureRecognizer(panGesture!)
    }

    func dynamicFilterList (filter: UIButton, parView: UIView) {
        filterD = filter
        listView = parView
        animator = UIDynamicAnimator(referenceView: listView!)
        let snapToNewCoordFilter = CGPoint(x: (filterD?.frame.origin.x)! + (filterD?.frame.width)!/2 , y: (listView?.frame.maxY)! - 114 )
        snapFilter = UISnapBehavior(item: filterD!, snapTo: snapToNewCoordFilter)
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(panFilter))
        self.filterD?.addGestureRecognizer(panGesture!)
    }
    

    
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
    
    @objc func panSort(pan: UIPanGestureRecognizer) {
        self.animator!.removeAllBehaviors()
        switch pan.state {
        case .began:
            sort?.center = pan.location(ofTouch: 0, in: listView)
        case .changed:
            sort?.center = pan.location(ofTouch: 0, in: listView)
        case .ended:
            self.animator!.addBehavior(self.snapSort!)
        default:
            break
        }
    }
    
    @objc func panFilter(pan: UIPanGestureRecognizer) {
        self.animator!.removeAllBehaviors()
        switch pan.state {
        case .began:
            filterD?.center = pan.location(ofTouch: 0, in: listView)
        case .changed:
            filterD?.center = pan.location(ofTouch: 0, in: listView)
        case .ended:
            self.animator!.addBehavior(self.snapFilter!)
        default:
            break
        }
    }
}
