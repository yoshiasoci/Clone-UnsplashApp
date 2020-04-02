//
//  PhotoCollectionCollectionViewCell.swift
//  Clone-UnsplashApp
//
//  Created by admin on 3/26/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotoCollectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionPhotoImage: UIImageView!
    @IBOutlet weak var collectionPhotoTitleLabel: UILabel!
    
    func populateCell(mediaUrl: String?, collectionTitle: String?) {
        if
            let thumbURLString = mediaUrl,
            let url = URL(string: thumbURLString) {
            collectionPhotoImage.af.setImage(withURL: url)
        } else {
            collectionPhotoImage.image = nil
        }
//        collectionPhotoImage.setImageFrom(mediaUrl!)
        collectionPhotoTitleLabel.text = collectionTitle
    }
    
     override func prepareForReuse() {
    //        activityIndicator.startAnimating()
            collectionPhotoImage.image = nil
        }
    
    
}
