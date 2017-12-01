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
    
    let values = [ "Bar","Cafe","Restaurant", "Bank","Night Club","Museum", "Beuty Salon","Pharmacy","Hospital","Bus Station","Gas Station","University","Police","Cemetery","Park","Gym"]
    
    let iconFilterArray = [#imageLiteral(resourceName: "bar"),#imageLiteral(resourceName: "cafe"),#imageLiteral(resourceName: "restaurant"), #imageLiteral(resourceName: "bank"),#imageLiteral(resourceName: "nightClub") ,#imageLiteral(resourceName: "museum"),#imageLiteral(resourceName: "beutySalon"),#imageLiteral(resourceName: "pharmacy"),#imageLiteral(resourceName: "hospital"),#imageLiteral(resourceName: "busStation"),#imageLiteral(resourceName: "gasStation"),#imageLiteral(resourceName: "university"), #imageLiteral(resourceName: "police"),#imageLiteral(resourceName: "cemetery"),#imageLiteral(resourceName: "park"),#imageLiteral(resourceName: "gym")]
    
   // let colorCellArray = [#colorLiteral(red: 0.862745098, green: 0.07843137255, blue: 0.2352941176, alpha: 1),#colorLiteral(red: 0.816177428, green: 0.3087009804, blue: 0.3607843137, alpha: 1),#colorLiteral(red: 1, green: 0.4054285386, blue: 0.3137254902, alpha: 1),#colorLiteral(red: 0.9803921569, green: 0.5019607843, blue: 0.4470588235, alpha: 1),#colorLiteral(red: 1, green: 0.6470588235, blue: 0, alpha: 1),#colorLiteral(red: 1, green: 0.8431372549, blue: 0, alpha: 1),#colorLiteral(red: 0.6039215686, green: 0.8039215686, blue: 0.1960784314, alpha: 1),#colorLiteral(red: 0.6784313725, green: 1, blue: 0.1843137255, alpha: 1),#colorLiteral(red: 0, green: 1, blue: 0, alpha: 1),#colorLiteral(red: 0, green: 1, blue: 0.4980392157, alpha: 1),#colorLiteral(red: 0.2352941176, green: 0.7019607843, blue: 0.4431372549, alpha: 1),#colorLiteral(red: 0.1254901961, green: 0.6980392157, blue: 0.6666666667, alpha: 1),#colorLiteral(red: 0.3921568627, green: 0.5843137255, blue: 0.9294117647, alpha: 1),#colorLiteral(red: 0.4823529412, green: 0.4078431373, blue: 0.9333333333, alpha: 1),#colorLiteral(red: 1, green: 0.5478362439, blue: 0.7764705882, alpha: 1),#colorLiteral(red: 1, green: 0.4463541667, blue: 0.7960784314, alpha: 1),#colorLiteral(red: 0.8549019608, green: 0.4392156863, blue: 0.8392156863, alpha: 1)]
    
    @IBOutlet weak var categoriesList: UITableView!
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoriesList.dequeueReusableCell(withIdentifier: "used") as! CategoriesViewCell
        
        cell.name.text = values[indexPath.row]
        //cell.name.backgroundColor = colorCellArray[indexPath.row]
        cell.picture.image = iconFilterArray[indexPath.row]
        //cell.backgroundColor = colorCellArray[indexPath.row]
        
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
        
        //categoriesList.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

protocol SetCategory: class {
    func setCategoryText(newText: String)
}
