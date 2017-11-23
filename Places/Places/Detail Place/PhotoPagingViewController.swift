//
//  PhotoPagingViewController.swift
//  Places
//
//  Created by Andrii Antoniak on 11/22/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class PhotoPagingViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    

    @IBOutlet weak var currentPhotoCollectionView: UICollectionView!
    
    @IBOutlet weak var allPhotoCollectionView: UICollectionView!
    
    var photoArray : [UIImage] = []
    
    var indexPath : IndexPath!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentPhotoCollectionView.delegate = self
        currentPhotoCollectionView.dataSource = self
        
        
        allPhotoCollectionView.delegate = self
        allPhotoCollectionView.dataSource = self
       
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        currentPhotoCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentPhotoCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell
        
        cell?.photoImageView?.image = photoArray[indexPath.row]
        

        return cell!
    }
   

}
