//
//  PhotoPagingViewController.swift
//  Places
//
//  Created by Andrii Antoniak on 11/22/17.
//  Copyright © 2017 andriibilan. All rights reserved.
//

import UIKit

class PhotoPagingViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: currentPhotoCollectionView.frame.width, height: currentPhotoCollectionView.frame.height)
    }
    
   

    @IBOutlet weak var currentPhotoCollectionView: UICollectionView!
    
    @IBOutlet weak var dismissButtonOutlet: UIButtonExplicit!
    
    
    
    var photoArray : [UIImage] = []
    
    var indexPath : IndexPath!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissButtonOutlet.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 180))
        dismissButtonOutlet.backgroundColor = #colorLiteral(red: 0.8338858485, green: 0.2595152557, blue: 0.3878593445, alpha: 1)
        
        
        
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
        
        return cell!
    }
    
   
    
    @IBAction func dismissButton(_ sender: UIButtonExplicit) {
        dismiss(animated: true, completion: nil)
    }
    
   
   
    
}
