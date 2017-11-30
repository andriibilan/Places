//
//  File.swift
//  Places
//
//  Created by Nazarii Melnyk on 11/23/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class UIImageViewExplicit: UIImageView{
    @IBInspectable
    var borderColor: UIColor? {
        get{
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set{
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get{
            return layer.borderWidth
        }
        set{
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var defaultImage: UIImage? = nil
}
