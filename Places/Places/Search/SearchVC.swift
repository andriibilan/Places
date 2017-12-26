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

class SearchVC: UIViewController, UITableViewDataSource, UITableViewDelegate,  UISearchBarDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        googlePlacesManager = GooglePlacesManager(
            apiKey: AppDelegate.apiKey,
            radius: UserDefaults.standard.integer(forKey: "Radius"),
            currentLocation: pressCoordinate,
            filters: PlaceType.all,
            completion: {foundedPlaces, errorMessage in
                if let errorMessage = errorMessage{
                    self.showAlert(message: errorMessage)
                }
                
                if let foundedPlaces = foundedPlaces{
                    self.filteredPlaces = foundedPlaces
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
    var filteredPlaces = [Place]()
    
    @IBOutlet weak var tableViewForPlaces: UITableViewExplicit!

	
	@IBOutlet weak var dismissButton: UIButton! {
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
        
        let placesCount = filteredPlaces.count
        
        return placesCount == 0 ? 1 : placesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let places = filteredPlaces
        
        if places.isEmpty {
            return tableView.dequeueReusableCell(withIdentifier: "No Item", for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ListTableViewCell
            let place = places[indexPath.row]
            
            // Loading cell with data
            
            cell.name.text = place.name ?? "No name"
            
            var typesNames = ""
            for type in place.types {
                typesNames += String(describing: type.printableStyle) + ", "
            }
            typesNames.removeLast()
            typesNames.removeLast()
            
            cell.type.text = typesNames
            
            switch place.isOpen {
            case true?:
                cell.openClosedImageView.image = #imageLiteral(resourceName: "open-sign")
            case false?:
                cell.openClosedImageView.image = #imageLiteral(resourceName: "closed-sign")
            default: break
            }
            
            if let distance = place.distance{
                if distance >= 1000{
                    cell.distance.text = String(describing: distance.km)
                }else {
                    cell.distance.text = String(describing: distance.m)
                }
            } else{
                cell.distance.text = "unknown m."
            }
            
            cell.thumbnailImageView.image = place.icon ?? cell.thumbnailImageView.defaultImage
            
            tableViewForPlaces.numberOfViewedRows += 1
            
            return cell
        }
    }
    
    // MARK: - TableView Delegate methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = filteredPlaces[indexPath.row]

        googlePlacesManager.getPhotos(ofPlace: place) {filledPlace, errorMessage in
            DispatchQueue.main.async {
                print(errorMessage ?? "")
                self.performSegue(withIdentifier: "ShowDetailPlace", sender: filledPlace)
            }
        }
    }
    
    // MARK: - SearchBar Delegate methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchPlaces), object: nil)
        self.perform(#selector(searchPlaces), with: searchText, afterDelay: 1.5)
    }
    
    @objc func searchPlaces(byName placeName: String){
        filteredPlaces.removeAll()
        
        for place in googlePlacesManager.foundedPlaces{
            if let name = place.name?.lowercased(){
                if name.hasPrefix(placeName.lowercased()){
                    filteredPlaces.append(place)
                }
            }
        }
        
        tableViewForPlaces.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    // MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailPlace" {
            if let detailVC = segue.destination as? DetailPlaceViewController {
                if let selectedPlace = sender as? Place {
                    detailVC.place = selectedPlace
                }
            }
        }
    }
    
}
