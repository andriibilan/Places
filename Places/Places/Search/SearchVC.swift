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
            apiKey: "AIzaSyDLxIv8iHmwytbkXR5Gs2U9rqoLixhXIXM",
            radius: UserDefaults.standard.integer(forKey: "Radius"),
            currentLocation: pressCoordinate,
            filters: MapViewController.checkFilter(filter: filterArray),
            completion: {_, errorMessage  in
                if errorMessage != nil{
                    print("\t\(errorMessage!)")
                    self.showAlert(message: "Cannot load places! Try it tomorrow ;)")
                }
                
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
}


extension SearchVC{
    // MARK: - TableView DataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewForPlaces.numberOfViewedRows = 0
        return googlePlacesManager.foundedPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let places = googlePlacesManager.foundedPlaces
        
        if places.isEmpty {
            return tableView.dequeueReusableCell(withIdentifier: "No Item", for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ListTableViewCell
            let place = places[indexPath.row]
            
            // Loading cell with data
            
            cell.name.text = place.name ?? "No name"
            
            switch place.isOpen{
            case true?:
                cell.openClosedImageView.image = #imageLiteral(resourceName: "open-sign")
            case false?:
                cell.openClosedImageView.image = #imageLiteral(resourceName: "closed-sign")
            case nil:
                cell.openClosedImageView.image = #imageLiteral(resourceName: "questionMark")
            }
            
            if let distance = place.distance{
                cell.distance.text = String(describing: distance)
            } else{
                cell.distance.text = "unknown m."
            }
            
            cell.thumbnailImageView.image = place.icon ?? cell.thumbnailImageView.defaultImage
            
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
