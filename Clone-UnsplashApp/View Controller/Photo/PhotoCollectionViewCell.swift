//
//  PhotoCollectionViewCell.swift
//  Clone-UnsplashApp
//
//  Created by admin on 3/24/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    func populateCell(mediaUrl: String?) {
        if
            let thumbURLString = mediaUrl,
            let url = URL(string: thumbURLString) {
            photoImageView.af.setImage(withURL: url)
        } else {
            photoImageView.image = nil
        }
    }
    
    override func prepareForReuse() {
        self.photoImageView.image = nil
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}

