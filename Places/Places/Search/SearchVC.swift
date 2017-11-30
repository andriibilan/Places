//
//  SearchVC.swift
//  Places
//
//  Created by Nazarii Melnyk on 11/21/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UITableViewDataSource, UISearchBarDelegate, GooglePlacesManagerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googlePlacesManager = GooglePlacesManager(
            apiKey: "AIzaSyCOrfXohc5LOn-J6aZQHqXc0nmsYEhAxQQ",
            radius: 50.m,
            currentLocation: Location.currentLocation(),
            filters: [PlaceType](),
            delegate: nil
        ){_ in
            DispatchQueue.main.async { [weak self] in
                self?.tableViewForPlaces.reloadData()
            }
        }
    }
    
    var googlePlacesManager: GooglePlacesManager!
    
    @IBOutlet weak var tableViewForPlaces: UITableViewExplicit!
	
	
	@IBOutlet weak var dismissButton: UIButton!{
		didSet{
			dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
			dismissButton.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 180))
		}
	}
	
	@IBAction func dismissButtonTaped(_ sender: UIButton) {
		print(UserDefaults.standard.integer(forKey: "Radius"))
		
		performSegue(withIdentifier: "exitFromSearch", sender: self)
		
		
	}

    func updateUIMaker() -> ([Place], Int?, String?) -> (){
        let passedTableView = tableViewForPlaces!
        
        func updateUI(foundedPlaces: [Place], placeIndex: Int?, valueName: String?){
            if let index = placeIndex{
                let places = googlePlacesManager.foundedPlaces
                
                DispatchQueue.main.async {
                    if passedTableView.numberOfRows(inSection: 1) == places.count{
                        let indexPath = IndexPath(row: index + 1, section: 1)
                        
                        print(index)
                        passedTableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }else {
                DispatchQueue.main.async {
                    passedTableView.reloadData()
                }
            }
        }

        return updateUI
    }
}


extension SearchVC{
    // MARK: - TableView DataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewForPlaces.numberOfViewedRows = 0
        return googlePlacesManager.getFoundedPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let places = googlePlacesManager.getFoundedPlaces
        
        if places.isEmpty {
            return tableView.dequeueReusableCell(withIdentifier: "No Item", for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemCell
            let place = places[indexPath.row]
            
            // Load the cell with data
            cell.placeName.text = place.name ?? "no name"
            
            switch place.isOpen{
            case true?: cell.placeOpenStatus.text = "Open now"
            case false?: cell.placeOpenStatus.text = "Closed now"
            case nil: cell.placeOpenStatus.text = "Unknown"
            }
            
            if let distance = place.distance{
                cell.distanceToPlace.text = String(describing: distance)
            } else{
                cell.distanceToPlace.text = "unknown m."
            }
            
            if let titlePhoto = place.icon{
                cell.previewImage.image = titlePhoto
            } else{
                cell.previewImage.image = cell.previewImage.defaultImage
            }
            
            tableViewForPlaces.numberOfViewedRows += 1
            
            return cell
        }
    }
    
    // MARK: - GooglePlacesManagerDelegate methods

    func loadedDataAt(index: Int, dataName: String?) {
        DispatchQueue.main.async { [weak self] in
            dataName // used for debuging
            if self?.tableViewForPlaces.numberOfViewedRows == self?.googlePlacesManager.getFoundedPlaces.count{
                let indexPath = IndexPath(row: index + 1, section: 1)
                
                print(index)
                self?.tableViewForPlaces.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func loadedAllPlaces() {
        DispatchQueue.main.async { [weak self] in
            self?.tableViewForPlaces.reloadData()
        }
    }
    
    
    /*
    // MARK: - SearchBar Delegate methods
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        <#code#>
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        <#code#>
    }*/
    
}
