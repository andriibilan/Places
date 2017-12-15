//
//  CollectionViewDataSource.swift
//  Places
//
//  Created by Andrii Antoniak on 12/7/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation
import UIKit

extension DetailPlaceViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if place.photos.count == 0 {
            heightProportionalConstrainForPhotoColelctionView.isActive = false
            heightEqualConstraintForCollectionView.isActive = true
        }
        return place.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell
        if place.photos.count != 0 {
            cell?.photoImageView?.image = place.photos[indexPath.row]
        }
        cell?.layer.borderColor = #colorLiteral(red: 0.9211991429, green: 0.2922174931, blue: 0.431709826, alpha: 1)
        cell?.layer.borderWidth = 5
        return cell!
    }
}
