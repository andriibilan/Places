//
//  ExtensionForUIImage.swift
//  Places
//
//  Created by Roman Melnychok on 28.11.17.
//  Copyright © 2017 Roman Melnychok. All rights reserved.
//

import UIKit

extension UIImage {
	func resizedImage(withBounds bounds: CGSize) -> UIImage {
		let horizontalRatio = bounds.width / size.width
		let verticalRatio = bounds.height / size.height
		let ratio = min(horizontalRatio, verticalRatio)
		let newSize = CGSize(width: size.width * ratio,
							 height: size.height * ratio)
		UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
		draw(in: CGRect(origin: CGPoint.zero, size: newSize))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage!
	}
    static func loadImageFromPath(path: String) -> UIImage? {
        if let url = URL(string: path) {
            if let urlContents = try? Data(contentsOf: url) {
                return UIImage(data: urlContents)
            }
        }
        return nil
    }
}
