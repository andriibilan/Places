//
//  myAnnotation.swift
//  Places
//
//  Created by Victoriia Rohozhyna on 11/27/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation : NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var isOpen : Bool
    var enableInfoButton : Bool
    var image : UIImage?
    
    init(coordinate: CLLocationCoordinate2D, title: String, isOpen: Bool, enableInfoButton : Bool, image: UIImage) {
        self.coordinate = coordinate
        self.title = title
        self.isOpen = isOpen
        self.enableInfoButton = enableInfoButton;
        self.image = image
        if isOpen == true{
            subtitle = "Open now"
        } else {
            subtitle = "Closed"
        }
    }
    
    func annotationView() -> MKAnnotationView {
        let view = MKAnnotationView(annotation: self, reuseIdentifier: "CustomAnnotation")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isEnabled = true
        view.canShowCallout = true
        view.image = image
        view.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
        view.centerOffset = CGPoint(x: 0 ,y: -32)
 
        return view
    }
    
    func infoClicked(sender: AnyObject?) {
        
        print("infoClicked")
        
    }
    
}
