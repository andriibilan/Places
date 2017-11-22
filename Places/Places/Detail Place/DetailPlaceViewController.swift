//
//  DetailPlaceViewController.swift
//  Places
//
//  Created by Andrii Antoniak on 11/22/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class DetailPlaceViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var photoArray :[UIImage] = []
    
    @IBOutlet weak var PhotoCollectionView: UICollectionView!
    
    //TODO: load real image when I'll have choosing place
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoArray.append(#imageLiteral(resourceName: "noPhotoIcon"))
        photoArray.append(#imageLiteral(resourceName: "noPhotoIcon"))
        photoArray.append(#imageLiteral(resourceName: "noPhotoIcon"))
        photoArray.append(#imageLiteral(resourceName: "noPhotoIcon"))
        photoArray.append(#imageLiteral(resourceName: "noPhotoIcon"))
        photoArray.append(#imageLiteral(resourceName: "noPhotoIcon"))
        photoArray.append(#imageLiteral(resourceName: "noPhotoIcon"))
        photoArray.append(#imageLiteral(resourceName: "noPhotoIcon"))
        photoArray.append(#imageLiteral(resourceName: "noPhotoIcon"))
        photoArray.append(#imageLiteral(resourceName: "noPhotoIcon"))
        photoArray.append(#imageLiteral(resourceName: "noPhotoIcon"))
        photoArray.append(#imageLiteral(resourceName: "noPhotoIcon"))
        
        if  photoArray.count == 0{
            photoArray.append(#imageLiteral(resourceName: "noPhotoIcon"))
        }
        PhotoCollectionView.delegate = self
        PhotoCollectionView.dataSource = self
        
    }

    //TODO: IF item is selected than go to PhotoPagingViewController
    /*
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        <#code#>
    }
     */
    
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
