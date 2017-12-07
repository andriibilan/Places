//
//  ListViewController.swift
//  Places
//
//  Created by Roman Melnychok on 11/22/17.
//  Copyright © 2017 Roman Melnychok. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, OutputInterface {
    let listDynamic = Dynamic()
    public var places: [Place] = []
    private var openPlaces: [Place] = []
    private var filterOpenOnly = false
    private var sortingByName = true
     var googlePlacesManager: GooglePlacesManager!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sortingButton: UIButton! {
        didSet {
            sortingButton.layer.cornerRadius = sortingButton.bounds.width / 2
            sortingButton.clipsToBounds = true
        }
    }
    @IBOutlet weak var filteringButton: UIButton! {
        didSet {
            filteringButton.layer.cornerRadius = filteringButton.bounds.width / 2
            filteringButton.clipsToBounds = true
        }
    }
    @IBAction func sortingButtonTapped(_ sender: UIButton) {
        if sortingByName {
            sender.setImage( #imageLiteral(resourceName: "name-sorting"), for: .normal)
            sortingByName = false
            places.sort(by: {($0.name ?? "") < ($1.name ?? "")})
        } else {
            sender.setImage(#imageLiteral(resourceName: "distance-sorting"), for: .normal)
            sortingByName = true
            places.sort(by: {($0.distance ?? 0) < ($1.distance ?? 0)})
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
    
    private func scaleAnimation(onButton button:UIButton) {
        button.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        UIView.animate(withDuration: 0.5, delay: 0, options: .allowUserInteraction, animations: {
            [button] in button.transform = CGAffineTransform.identity
            }, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 148, right: 0)
        tableView.tableFooterView = UIView()
        listDynamic.dynamicSort(button: sortingButton, parView: self.view)
        listDynamic.dynamicFilterList(filter: filteringButton, parView: self.view)

    }
    
    private func refillOpenPlaces() {
        if filterOpenOnly {
            openPlaces = places.filter {
                if $0.isOpen != nil {
                    return $0.isOpen! == true
                } else {
                    return false
                }
            }
        } else {
            openPlaces = places
        }
    }
    
   
    func updateData() {
        loadVC.customActivityIndicatory(self.view, startAnimate: true).startAnimating()
        googlePlacesManager = GooglePlacesManager(apiKey: AppDelegate.apiKey, radius: UserDefaults.standard.integer(forKey: "Radius"), currentLocation: pressCoordinate, filters: MapViewController.checkFilter(filter: filterArray), completion: { (foundedPlaces, errorMessage) in
            if errorMessage != nil {
                self.showAlert(message: "Cannot load all places! Try it tomorrow ;)")
                DispatchQueue.main.sync {
                    loadVC.customActivityIndicatory(self.view, startAnimate: false).stopAnimating()
                }
            }
            if let foundedPlaces = foundedPlaces {
                self.places = foundedPlaces
                self.places.sort(by: {($0.distance ?? 0) < ($1.distance ?? 0)})
               
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                    loadVC.customActivityIndicatory((self.view)!, startAnimate: false).stopAnimating()
                    }
                
        }
    })
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
            let place = (filterOpenOnly) ? openPlaces[safe: indexPath.row] : places[safe: indexPath.row]
            //placeholder image
            cell.thumbnailImageView.image = place?.icon
            //name
            cell.name.text = place?.name
            //distance
            if let distance = place?.distance {
                cell.distance.text	= updateDistance(distance: distance)
            } else {
                cell.distance.text	= ""
            }
            //place type
            if place?.types != nil {
                cell.type.text = typePlaces(types: (place?.types)!)
            }
            //Open/Closed
            cell.openClosedImageView.image = nil
            if let placeIsOpen = place?.isOpen {
                if placeIsOpen {
                    cell.openClosedImageView.image = #imageLiteral(resourceName: "open-sign")
                } else {
                    cell.openClosedImageView.image = #imageLiteral(resourceName: "closed-sign")
                }
            }
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
    
   private func typePlaces (types: [PlaceType]) -> String {
        var stringType = ""
        for type in types {
            stringType += type.rawValue + ", "
        }
        stringType.removeLast()
        stringType.removeLast()
        return stringType
    }

    private func updateDistance(distance: Int) -> String {
        if UserDefaults.standard.bool(forKey: "distanceIskm") == true {
            if distance < 1000 {
                return "\(distance) m."
            } else {
                return "\((Double(distance).kilometr).rounded(toPlaces: 2)) km."
            }
        } else {
            return "\((Double(distance).miles).rounded(toPlaces: 2)) ml."
        }
    }
 
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = (filterOpenOnly) ? openPlaces[safe: indexPath.row] : places[safe: indexPath.row]
        googlePlacesManager.getPhotos(ofPlace: place!){ filledPlace, errorMessage in
                DispatchQueue.main.async {
                    print(errorMessage ?? "")
                    self.performSegue(withIdentifier: "ShowDetailPlace", sender: filledPlace)
                }
            }
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "ShowDetailPlace" {
            let d = segue.destination as? DetailPlaceViewController
            d?.place = sender as! Place
		}
	}
    
}
