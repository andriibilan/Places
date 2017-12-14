//
//  DetailPlaceCollectionViewDelegate.swift
//  Places
//
//  Created by Andrii Antoniak on 12/14/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation
import UIKit

extension DetailPlaceViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailToPhoto", sender:  indexPath)
    }
}
