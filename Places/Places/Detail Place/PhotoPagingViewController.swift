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
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    
    
    var photoArray : [UIImage] = []
    
    var indexPath : IndexPath!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewFlowLayout.itemSize = currentPhotoCollectionView.frame.size
        print(currentPhotoCollectionView.frame.width)
        print(currentPhotoCollectionView.frame.size)
        
        
        
        currentPhotoCollectionView.delegate = self
        currentPhotoCollectionView.dataSource = self
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        currentPhotoCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell
        cell?.photoImageView?.image = photoArray[indexPath.row]
        print("image: \(cell?.photoImageView?.frame.width)")
       

        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        print("123321")
    }
    /*
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPhotoCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
    }
*/
}
