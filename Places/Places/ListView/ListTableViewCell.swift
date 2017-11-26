//
//  ListTableViewCell.swift
//  Places
//
//  Created by Roman Melnychok on 11/23/17.
//  Copyright © 2017 Roman Melnychok. All rights reserved.
//

import UIKit


class ListTableViewCell: UITableViewCell {
	
	@IBOutlet weak var thumbnailImageView: UIImageView! {
		didSet {
			thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
			thumbnailImageView.clipsToBounds = true
		}
	}

	@IBOutlet weak var name: UILabel!
		{
		didSet {
			name.numberOfLines = 0
		}
	}
	@IBOutlet weak var type: UILabel!
		{
		didSet {
			type.numberOfLines = 0
		}
	}
	@IBOutlet weak var openClosedImageView: UIImageView!
	@IBOutlet weak var distance: UILabel!
		{
		didSet {
			distance.numberOfLines = 0
		}
	}
	
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	
	
	func configureCell(with place: PlaceTemp)  {
		
		thumbnailImageView.image = #imageLiteral(resourceName: "marker")
		name.text = place.name 
		openClosedImageView.image = nil

		//Open/Closed
		let placeIsOpen = place.isOpen ?? false

		if placeIsOpen {
			openClosedImageView.image = #imageLiteral(resourceName: "open-sign")
		} else {
			openClosedImageView.image = #imageLiteral(resourceName: "closed-sign")
		}
		

		distance.text = "\( place.distance.rounded(toPlaces: 2)) м."

		type.text = place.type

		
		
	}
	
}

