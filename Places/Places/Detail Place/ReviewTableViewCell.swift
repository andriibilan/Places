//
//  ReviewTableViewCell.swift
//  Places
//
//  Created by Andrii Antoniak on 11/27/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelForReview: UILabel?
    
    @IBOutlet weak var labelForReviewer: UILabel?
    
    @IBOutlet weak var viewForRatting: UIView?
    
    @IBOutlet weak var ImageViewForIcon: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
