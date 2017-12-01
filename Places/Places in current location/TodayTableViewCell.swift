//
//  TodayTableViewCell.swift
//  Places In Current Location
//
//  Created by Andrew on 11/30/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class TodayTableViewCell: UITableViewCell {

    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var plaseIsOpen: UILabel!
    @IBOutlet weak var placeDistance: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
