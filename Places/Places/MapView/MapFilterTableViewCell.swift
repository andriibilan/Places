//
//  MapFilterTableViewCell.swift
//  Places
//
//  Created by andriibilan on 11/24/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class MapFilterTableViewCell: UITableViewCell {

    
    @IBOutlet weak var iconFilter: UIImageView!
    @IBOutlet weak var nameFilter: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
