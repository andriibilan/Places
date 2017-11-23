//
//  DetailPlaceViewController.swift
//  Places
//
//  Created by Andrii Antoniak on 11/22/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class DetailPlaceViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var PhotoCollectionView: UICollectionView!
    
    var photoArray :[UIImage] = []
    
    //TODO: load real image when I'll have choosing place
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoArray.append(#imageLiteral(resourceName: "noPhotoIcon"))
        photoArray.append(#imageLiteral(resourceName: "phone number"))
        photoArray.append(#imageLiteral(resourceName: "path"))
        photoArray.append(#imageLiteral(resourceName: "ratting"))
        photoArray.append(#imageLiteral(resourceName: "website"))
        photoArray.append(#imageLiteral(resourceName: "share"))
        photoArray.append(#imageLiteral(resourceName: "address"))
        photoArray.append(#imageLiteral(resourceName: "opening hours"))
        photoArray.append(#imageLiteral(resourceName: "path"))
        photoArray.append(#imageLiteral(resourceName: "ratting"))
        photoArray.append(#imageLiteral(resourceName: "phone number"))
        photoArray.append(#imageLiteral(resourceName: "website"))
        
        if  photoArray.count == 0{
            photoArray.append(#imageLiteral(resourceName: "ratting"))
        }
        PhotoCollectionView.delegate = self
        PhotoCollectionView.dataSource = self
        
    }

    //TODO: IF item is selected than go to PhotoPagingViewController
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO: here must returning current image with current image but not today
        performSegue(withIdentifier: "DetailToPhoto", sender:  indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailToPhoto"{
            let photoVC = segue.destination as! PhotoPagingViewController
            
            for temp in photoArray{
                photoVC.photoArray.append(temp)
            }
            photoVC.photoArray = self.photoArray
            photoVC.indexPath = sender as? IndexPath
        }
    }
    
    
    
    //MARK: Collection View Data Source
    
    //function for returning number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    //function for filling my cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell
        
        if photoArray.count != 0{
            cell?.photoImageView?.image = photoArray[indexPath.row]
        }else{
            cell?.photoImageView?.image = #imageLiteral(resourceName: "noPhotoIcon")
        }
        return cell!
    }
}
