//
//  ItemCell.swift
//  Places
//
//  Created by Nazarii Melnyk on 11/20/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var previewImage: UIImageViewExplicit!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeOpenStatus: UILabel!
    @IBOutlet weak var distanceToPlace: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
