//
//  ViewController.swift
//  Places
//
//  Created by andriibilan on 11/22/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var menuView: UIViewX!
    
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.isHidden = false
            listView.isHidden = true
        case 1:
            mapView.isHidden = true
            listView.isHidden = false
        default:
            break
        }
    }
	
	private let transition = CustomTransitionAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listView.isHidden = true
        menuView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func menuTapped(_ sender: FloatingActionButton) {
        UIView.animate(withDuration: 0.3, animations: {
            if self.menuView.transform == .identity {
                self.menuView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            } else {
                self.menuView.transform = .identity
            }
        })
    }
	
	
	//MARK:- Custom Transition
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		transition.transitionMode = .present
		transition.startingPoint = menuView.center
		transition.circleColor = menuView.backgroundColor!
		
		return transition
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		transition.transitionMode = .dismiss
		transition.startingPoint = menuView.center
		transition.circleColor = menuView.backgroundColor!
		
		return transition
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowSettings" {
			let secondVC = segue.destination as! SettingsViewController
			secondVC.transitioningDelegate = self
			secondVC.modalPresentationStyle = .custom
		}
		if segue.identifier == "ShowLogin" {
			let secondVC = segue.destination as! LoginViewController
			secondVC.transitioningDelegate = self
			secondVC.modalPresentationStyle = .custom
		}

	}
    
}

