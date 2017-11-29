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
    var enableInfoButton : Bool
    var image : UIImage?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, enableInfoButton : Bool, image: UIImage) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.enableInfoButton = enableInfoButton;
        self.image = image
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
