//
//  ViewController.swift
//  Places
//
//  Created by andriibilan on 11/22/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!

    private lazy var mapViewController: MapViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)  // Load Storyboard
        var viewController = storyboard.instantiateViewController(withIdentifier: "mapVC") as! MapViewController     // Instantiate View Controller
        self.addChildViewController(viewController)  // Add View Controller as Child View Controller
        return viewController
    }()
    
    private lazy var listViewController: ListViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)   // Load Storyboard
        var viewController = storyboard.instantiateViewController(withIdentifier: "listVC") as! ListViewController  // Instantiate View Controller
        self.addChildViewController(viewController)
        return viewController
    }()
    
    private func add(asChildViewController viewController: UIViewController) {
        childView.addSubview(viewController.view)       // Add Child View as Subview
        // Configure Child View
        viewController.view.frame = childView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)   // Notify Child View Controller
        viewController.view.removeFromSuperview()     // Remove Child View From Superview
        viewController.removeFromParentViewController()     // Notify Child View Controller
    }
    
  private func setupView() {
        setupSegmentedControl()
        updateView()
    }
    
    private func setupSegmentedControl() {
        // Configure Segmented Control
        segmentControl.removeAllSegments()
        segmentControl.insertSegment(withTitle: "Map", at: 0, animated: false)
        segmentControl.insertSegment(withTitle: "List", at: 1, animated: false)
        segmentControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        
        // Select First Segment
       segmentControl.selectedSegmentIndex = 0
    }
   
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
   
    private func updateView() {
        if segmentControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: listViewController)
            add(asChildViewController: mapViewController)
        } else {
            remove(asChildViewController: mapViewController)
            add(asChildViewController: listViewController)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
      
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
}

