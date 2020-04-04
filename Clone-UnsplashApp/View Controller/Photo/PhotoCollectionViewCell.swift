//
//  PhotoCollectionViewCell.swift
//  Clone-UnsplashApp
//
//  Created by admin on 3/24/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageViewWithLoading: CustomImageView!
    func populateCell(mediaUrl: String?) {
        photoImageViewWithLoading.ImageViewLoading(mediaUrl: mediaUrl!)
    }
    
    override func prepareForReuse() {
        self.photoImageViewWithLoading.image = nil
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}

