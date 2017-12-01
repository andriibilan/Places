//
//  DlistViewController.swift
//  Places
//
//  Created by adminaccount on 11/28/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class DlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: SetCategory?
   
    let destination = "toAddBoard"
    
    let values = [ "bar", "cafe", "restaurant", "bank", "night_club", "museum", "beauty_salon", "pharmacy", "hospital", "bus_station", "gas_station", "university", "police", "cemetery", "park", "gym"]
  
    @IBOutlet weak var categoriesList: UITableView!
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoriesList.dequeueReusableCell(withIdentifier: "used") as! CategoriesViewCell
        
        cell.name.text = values[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.setCategoryText(newText: values[indexPath.row])
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == destination {
            let viewController = segue.destination as? DlistViewController
            viewController?.delegate = delegate
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoriesList.dataSource = self
        categoriesList.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

protocol SetCategory: class {
    func setCategoryText(newText: String)
}
