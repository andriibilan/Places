//
//  SearchVC.swift
//  Places
//
//  Created by Nazarii Melnyk on 11/21/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UITableViewDataSource, UISearchBarDelegate, SearchManagerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBOutlet weak var tableView: UITableView!
    
    var places = [Place]()
    
    var searchManager = SearchManager(
        apiKey: "AIzaSyCOrfXohc5LOn-J6aZQHqXc0nmsYEhAxQQ",
        radius: 50.m,
        currentLocation: Location.currentLocation(),
        delegate: self as? SearchManagerDelegate
    )
}

extension SearchVC{
    // MARK: - TableView DataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            
            // need to upload all photos from array (in scrollView, I think)
            if !place.photos.isEmpty{
                cell.previewImage.image = place.photos[0]
            } else{
                cell.previewImage.image = cell.previewImage.defaultImage
            }
            
            return cell
        }
    }
    
    // MARK: - SearchManagerDelegate methods
    func reloadRowAt(index: Int) {
        places = searchManager.foundedPlaces
        
        let indexPath = IndexPath(row: index, section: 1)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func reloadAllData() {
        places = searchManager.foundedPlaces
        
        tableView.reloadData()
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
