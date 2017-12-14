//
//  TableViewDataSource.swift
//  Places
//
//  Created by Andrii Antoniak on 12/7/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import Foundation
import UIKit

extension DetailPlaceViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return place.reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let review = place.reviews[indexPath.row]
        let cell  = feedbackTableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewTableViewCell
        cell.layer.cornerRadius = 15
        cell.layer.borderColor = #colorLiteral(red: 0.2275260389, green: 0.6791594625, blue: 0.5494497418, alpha: 1)
        cell.layer.borderWidth = 1.5
        cell.labelForReview?.text = review.text
        cell.labelForReview?.backgroundColor? = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.labelForReview?.textColor = #colorLiteral(red: 0.9211991429, green: 0.2922174931, blue: 0.431709826, alpha: 1)
        cell.labelForReviewer?.text = review.author
        cell.labelForReviewer?.textColor = #colorLiteral(red: 0.2275260389, green: 0.6791594625, blue: 0.5494497418, alpha: 1)
        cell.viewForRatting?.addSubview(Rating(x: 0.0, y: 0.0, height: Double((cell.viewForRatting?.frame.height)!), currentRate: Double(review.rating!)))
        if let _ = review.profilePhotoUrl {
            cell.ImageViewForIcon?.image = UIImage.loadImageFromPath(path: review.profilePhotoUrl!)
        }
        return cell
    }
}
