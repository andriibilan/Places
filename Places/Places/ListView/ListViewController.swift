//
//  ListViewController.swift
//  Places
//
//  Created by andriibilan on 11/22/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

//MARK:-TEMP
class PlaceTemp {
	
	var name:String?
	var isOpen:Bool?
	var distance:Double?
	var imageURL:[String]?
	
}

class ListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	
	
	public var places:[PlaceTemp] = []
	private var searchResults: [PlaceTemp] = []
	private var searchController: UISearchController!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self
		
		
		//
		tableView.tableFooterView = UIView()
		//tableView.estimatedRowHeight = 120
		//tableView.rowHeight = UITableViewAutomaticDimension
		
		for _ in 0...10 {
			places.append(PlaceTemp())
		}
		
		
		
	}
	
	
	//MARK:- TableView DataSource
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10//places.count
	}
	
	
	//MARK:- TableView Delegate
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		
		if let cell = tableView.dequeueReusableCell(withIdentifier: "listTableView", for: indexPath) as? ListTableViewCell {
			
			//let place = (isFilterActive) ? searchResults[indexPath.row] : places[indexPath.row]
			let place  = places[indexPath.row]
			
			
			cell.configureCell(with:place)
			
			
			return cell
		}
		
		return UITableViewCell()
		
		
	}
	
	
	//MARK: - SEARCH
	var isFilterActive: Bool {
		return false//(searchController.isActive && searchController.searchBar.text != "")
	}
	
	
}

