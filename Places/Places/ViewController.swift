//
//  ViewController.swift
//  Places
//
//  Created by andriibilan on 11/22/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UIViewControllerTransitioningDelegate {
   
    var map : MapViewController?
    var listObj : ListViewController?
    var menuIsOpen = false
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var menuView: UIViewExplicit!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
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

    
    @IBAction func profileButton(_ sender: Any) {
		if Auth.auth().currentUser != nil {
			performSegue(withIdentifier: "ShowProfile", sender: nil)
		}
		else {
			performSegue(withIdentifier: "ShowLogin", sender: nil)
		}
		
	}
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        listView.isHidden = true
        menuView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        print("fgh")
    }
    
    @IBAction func menuTapped(_ sender: FloatingActionButton) {
        animateThemeView(expand: !menuIsOpen)
        UIView.animate(withDuration: 0.3, animations: {
            if self.menuView.transform == .identity {
                self.menuView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            } else {
                self.menuView.transform = .identity
            }
        })
    }
    
    //MARK:- Custom compass animations
    
    func animateThemeView(expand: Bool) {
        menuIsOpen = expand
        if menuIsOpen == true {
            map?.compassButtonConstraint.constant = 200
            UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            map?.compassButtonConstraint.constant = 90
            UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
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
		
		if segue.identifier == "ShowProfile" {
			let secondVC = segue.destination as! ProfileViewController
			secondVC.transitioningDelegate = self
			secondVC.modalPresentationStyle = .custom
		}
		
		if segue.identifier == "ShowSearch" {
			let secondVC = segue.destination as! SearchVC
			secondVC.transitioningDelegate = self
			secondVC.modalPresentationStyle = .custom
		}

		
		
		if segue.identifier == "ShowLogin" {
			let secondVC = segue.destination as! LoginViewController
			secondVC.transitioningDelegate = self
			secondVC.modalPresentationStyle = .custom
		}
        if segue.identifier == "MapView" {
            map = segue.destination as? MapViewController
        }
        if segue.identifier == "ListView" {
           listObj = segue.destination as? ListViewController
          
        }

	}
    
    @IBAction func unwindFromSettings(segue: UIStoryboardSegue) {
        if mapView.isHidden == false {
            map?.updateData()
             print("List hiidden? \(listView.isHidden)")
        } else {
            if let listVC = listObj {
                print("List hiidden? \(self.listView.isHidden)")
                listVC.updateData()
            }else{
                print("ERRRORR")
            }
        }

    }
    
    @IBAction func unwindFromProfile(segue: UIStoryboardSegue) {
       
    }
    
	@IBAction func unwindFromSearch(segue: UIStoryboardSegue) {
		
	}
    
}

protocol OutputInterface {
    func updateData()
}

