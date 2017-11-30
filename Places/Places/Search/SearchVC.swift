//
//  SearchVC.swift
//  Places
//
//  Created by Nazarii Melnyk on 11/21/17.
//  Copyright © 2017 Andrew. All rights reserved.
//

/*
 'NSInternalInconsistencyException', reason: 'attempt to delete row 1 from section 1, but there are only 1 sections before the update'
 
 what is that ???!
*/


import UIKit

class SearchVC: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googlePlacesManager = GooglePlacesManager(
            apiKey: "AIzaSyCOrfXohc5LOn-J6aZQHqXc0nmsYEhAxQQ",
            radius: 100.m,
            currentLocation: Location.Lviv,
            filters: [.restaurant, .bar],
            completion: {_ in
                DispatchQueue.main.async { [weak self] in
                    self?.tableViewForPlaces.reloadData()
                }
        })
        
        /*
        Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false){ [weak self] _ in
            if self == nil { return }
            
            if (self?.tableViewForPlaces.numberOfViewedRows)! >= 1 {
                self?.googlePlacesManager.getRealDistance(toPlaceIndex: 0, toPlace: nil){_ in
                    DispatchQueue.main.async { [weak self] in
                        self?.tableViewForPlaces.reloadData()
                    }
                }
                self?.googlePlacesManager.getPhotos(ofPlaceIndex: nil, ofPlace: self?.googlePlacesManager.foundedPlaces[0]){_ in
                    self?.googlePlacesManager
                    print("\n\tcheck now!")
                }
            }
        }
         */
    }
    
    var googlePlacesManager: GooglePlacesManager!
    
    @IBOutlet weak var tableViewForPlaces: UITableViewExplicit!
    
    
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
            
            // Loading cell with data
            cell.placeName.text = place.name ?? "no name"
            
            switch place.isOpen{
            case true?:
                cell.placeOpenStatus.text = "Open"
                // switch color
            case false?:
                cell.placeOpenStatus.text = "Closed"
                // switch color
            case nil:
                cell.placeOpenStatus.text = "Unknown"
                // switch color
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
    

    /*
    // MARK: - SearchBar Delegate methods
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        <#code#>
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        <#code#>
    }*/
    
}
