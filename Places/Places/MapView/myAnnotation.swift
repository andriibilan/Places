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
    var isOpen : Bool?
    var image : UIImage?
    var place:Place!
    
    init(place: Place) {
        self.coordinate = CLLocationCoordinate2DMake((place.location?.latitude)!, (place.location?.longitude)!)
        self.place = place
        self.title = place.name
        self.isOpen = place.isOpen
        self.image = place.icon
        if place.isOpen == true{
            subtitle = "Open now"
        } else {
            subtitle = "Closed"
        }
        
    }

    func annotationView() -> myAnnotationView {
        let view = myAnnotationView(annotation: self, reuseIdentifier: "CustomAnnotation")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isEnabled = true
        view.canShowCallout = true
        if image != nil {
        view.image = image?.resizedImage(withBounds: CGSize(width: 40.0, height: 40.0))
        } else {
            view.image = #imageLiteral(resourceName: "mops")
        }
        view.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
        view.centerOffset = CGPoint(x: 0 ,y: -32)
 
        return view
    }
    
    func infoClicked(sender: AnyObject?) {        
        print("infoClicked")
    }
}

class myAnnotationView : MKPinAnnotationView {
     var place:Place!
    
}


