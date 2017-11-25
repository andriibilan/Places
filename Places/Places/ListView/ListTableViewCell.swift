//
//  ListTableViewCell.swift
//  Places
//
//  Created by andriibilan on 11/23/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit


class ListTableViewCell: UITableViewCell {
	
	@IBOutlet weak var imageIcon: UIImageView!
	@IBOutlet weak var namePlace: UILabel!
	@IBOutlet weak var isOpen: UILabel!
	@IBOutlet weak var distanceToUser: UILabel!
	
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	
	
	func configureCell(with place: PlaceTemp)  {
		
		imageIcon.image = #imageLiteral(resourceName: "noPhotoIcon")
		namePlace.text = "temp"
		isOpen.text = "open"
		isOpen.textColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
		
	}
	
}

