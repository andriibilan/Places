//
//  ListViewController.swift
//  Places
//
//  Created by Roman Melnychok on 11/22/17.
//  Copyright © 2017 Roman Melnychok. All rights reserved.
//

import UIKit

//MARK:-TEMP
class PlaceTemp {
	
	var name:String = ""
	var isOpen:Bool?
	var distance:Double = 0.0
	var photos:[String]?
	var type: String
	
	
	init(name: String, isOpen: Bool, distance: Double, photos: [String], type:String ) {
		
		self.name = name
		self.isOpen = isOpen
		self.distance = distance
		self.photos = photos
		self.type = type
		
	}
	
}

class ListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	
	@IBOutlet weak var sortingButton: UIButton! {
		didSet {
			sortingButton.layer.cornerRadius = sortingButton.bounds.width / 2
			sortingButton.clipsToBounds = true
		}
	}
	
	@IBOutlet weak var filteringButton: UIButton!{
		didSet {
			filteringButton.layer.cornerRadius = filteringButton.bounds.width / 2
			filteringButton.clipsToBounds = true
		}
	}
	
	@IBAction func sortingButtonTapped(_ sender: UIButton) {
		
		
		if sortingByName {
			sender.setImage( #imageLiteral(resourceName: "name-sorting"), for: .normal)
			sortingByName = false
			places.sort(by: {$0.name < $1.name})
			
		} else {
			sender.setImage(#imageLiteral(resourceName: "distance-sorting"), for: .normal)
			sortingByName = true
			places.sort(by: {$0.distance < $1.distance})
		}
		
		//perform scale animation
		scaleAnimation(onButton: sender)

		refillOpenPlaces()
		
		self.tableView.reloadData()
	}
	
	@IBAction func filteringButtonTapped(_ sender: UIButton) {
		
		if !filterOpenOnly {
			sender.setImage( #imageLiteral(resourceName: "clear-filter"), for: .normal)
			filterOpenOnly = true
		} else {
			sender.setImage(#imageLiteral(resourceName: "filter"), for: .normal)
			filterOpenOnly = false
		}
		
		//perform scale animation
		scaleAnimation(onButton: sender)
		
		refillOpenPlaces()
		
		self.tableView.reloadData()
		
	}
	
	private func scaleAnimation(onButton button:UIButton)  {
		button.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
		UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
			[button] in button.transform = CGAffineTransform.identity
			}, completion: nil)
	}
	
	
	
	public var places:[PlaceTemp] = []
	private var openPlaces: [PlaceTemp] = []
	private var filterOpenOnly = false
	private var sortingByName = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self
		
		
		//
		tableView.tableFooterView = UIView()
		//tableView.estimatedRowHeight = 120
		//tableView.rowHeight = UITableViewAutomaticDimension
		
		
		//[+] for testing only
		for i in 0...30 {
			
			var  open = true
			if (i % 2 == 0)  {
				open = true
			} else {
				open = false
			}
			
			places.append(PlaceTemp(name: "Name \(i)", isOpen: open , distance: ((Double(i) * 10.456) + 5.345), photos: ["hello"],type: "Restorant"))
		}
		//[-] for testing only
		
		
	}
	
	private func refillOpenPlaces() {
		
		if filterOpenOnly {
			openPlaces = places.filter{$0.isOpen! == true}
		} else {
			openPlaces = places
		}
		
	}
	
	//MARK:- TableView DataSource
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filterOpenOnly ? openPlaces.count : places.count
	}
	
	
	//MARK:- TableView Delegate
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		
		if let cell = tableView.dequeueReusableCell(withIdentifier: "listTableView", for: indexPath) as? ListTableViewCell {
			
			let place = (filterOpenOnly) ? openPlaces[indexPath.row] : places[indexPath.row]
			
			
			cell.configureCell(with:place)
			
			
			return cell
		}
		
		return UITableViewCell()
		
		
	}
	
	//MARK: - Fade in effect
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		// Define the initial state (Before the animation)
		cell.alpha = 0
		
		// Define the final state (After the animation)
		UIView.animate(withDuration: 0.75, animations: { cell.alpha = 1 })

	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	
	
}

