//
//  PhotoCollectionCollectionViewCell.swift
//  Clone-UnsplashApp
//
//  Created by admin on 3/26/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class PhotoCollectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionPhotoImageWithLoading: CustomImageView!
    @IBOutlet weak var collectionPhotoTitleLabel: UILabel!
    
    func populateCell(mediaUrl: String?, collectionTitle: String?) {
        collectionPhotoImageWithLoading.ImageViewLoading(mediaUrl: mediaUrl!)
        collectionPhotoTitleLabel.text = collectionTitle
    }
    
     override func prepareForReuse() {
        collectionPhotoImageWithLoading.image = nil
    }
    
}
