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



class ListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, OutputInterface {
    
    func updateData() {
        tableView.reloadData()
    }
    
	
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
		button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
		UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
			[button] in button.transform = CGAffineTransform.identity
			}, completion: nil)
	}
	
	
	
	public var places:[PlaceTemp] = []
	private var openPlaces: [PlaceTemp] = []
	private var filterOpenOnly = false
	private var sortingByName = true
	private var task: URLSessionDownloadTask!
	private var session: URLSession!
	private var cache:NSCache<AnyObject, AnyObject>!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 148, right: 0)
		
		//
		tableView.tableFooterView = UIView()
		//tableView.estimatedRowHeight = 120
		//tableView.rowHeight = UITableViewAutomaticDimension
		
		
		session = URLSession.shared
		task 	= URLSessionDownloadTask()
		cache	= NSCache()
		
		//[+] for testing only
		let urlTest = "https://s3-eu-west-1.amazonaws.com/romel/pokemon/"
		for i in 1...100 {
			
			var  open = true
			if (i % 2 == 0)  {
				open = true
			} else {
				open = false
			}
			
			places.append(PlaceTemp(name: "Name \(i)", isOpen: open , distance: ((Double(i) * 10.456) + 5.345), photos: [urlTest + "\(i).png"],type: "Restorant"))
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
			
			
			//placeholder image
			cell.thumbnailImageView.image = #imageLiteral(resourceName: "marker")
			
			//name
			cell.name.text		= place.name
			//distance
			cell.distance.text	= "\( place.distance.rounded(toPlaces: 2)) м."
			//place type
			cell.type.text		= place.type

			
			//Open/Closed
			cell.openClosedImageView.image = nil
			if let placeIsOpen = place.isOpen {
				if placeIsOpen {
					cell.openClosedImageView.image = #imageLiteral(resourceName: "open-sign")
				} else {
					cell.openClosedImageView.image = #imageLiteral(resourceName: "closed-sign")
				}
			}
			
			let urlString = place.photos![0]
			let url:URL! = URL(string: place.photos![0])
			
			//downloading/cashing image from internet
			if let cachedImage = (self.cache.object(forKey: (urlString as AnyObject) ) as? UIImage ) {
				//we are using cashe
				print("Using cashe - \(urlString)")
				cell.thumbnailImageView.image = cachedImage
				
			} else {
				//download image and add to cache
				
				task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
					if let data = try? Data(contentsOf: url){
						
						DispatchQueue.main.async(execute: { () -> Void in
							//DispatchQueue.global(qos: .background).async {
							// if the current cell is visible
							if let updateCell = self.tableView.cellForRow(at: indexPath) as? ListTableViewCell{
								let img:UIImage! = UIImage(data: data)
								
								//DispatchQueue.main.sync {
									updateCell.thumbnailImageView?.image = img
								//}
								self.cache.setObject(img, forKey: urlString as AnyObject)
								print("adding to cache - \(urlString)")
							}
						}
						)
					}
				})
				task.resume()
				
			}
			
			return cell
		}
		
		return UITableViewCell()
		
		
	}
	
	//MARK: - Fade in effect
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		// Define the initial state (Before the animation)
		//cell.alpha = 0
		
		// Define the final state (After the animation)
		//UIView.animate(withDuration: 0.75, animations: { cell.alpha = 1 })
				
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	
	
}

