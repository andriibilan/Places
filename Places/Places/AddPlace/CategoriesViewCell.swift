//
//  CategoriesViewCell.swift
//  Places
//
//  Created by adminaccount on 11/28/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class CategoriesViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var picture: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
