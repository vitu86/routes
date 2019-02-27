//
//  PhotosViewController.swift
//  Routes
//
//  Created by Vitor Costa on 26/02/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    // MARK: - View Controller Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // If not async, current orientation returns wrong value
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.configureUI()
        }
    }
    
    // MARK: - Private Functions
    private func configureUI() {
        // Configure Navigation Bar
        title = "Photos"
        
        // Configure Collection View Layout
        let space: CGFloat
        let dimension: CGFloat
        if (UIDevice.current.orientation.isPortrait) {
            space = 3.0
            dimension = (view.frame.size.width - (2 * space)) / 3
        } else {
            space = 1.0
            dimension = (view.frame.size.width - (1 * space)) / 5
        }
        collectionViewFlowLayout.minimumInteritemSpacing = space
        collectionViewFlowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        // Configure Collection View
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - Collection View Override Functions
extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photosCell", for: indexPath) as! PhotosCollectionViewCell
        cell.photoImageView.image = #imageLiteral(resourceName: "ImageIcon")
        cell.tintColor = UIColor(named: "BasePurple")
        return cell
    }
}

// MARK: - Collection View Cell - Customized
class PhotosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
}
