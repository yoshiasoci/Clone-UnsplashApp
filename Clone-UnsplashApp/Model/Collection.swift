//
//  Collection.swift
//  Clone-UnsplashApp
//
//  Created by admin on 3/23/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

struct PhotoCollection: Decodable {
    var id: Int
    var title: String
    var cover_photo: PhotoList
}

//Search Collection
struct SearchPhotoCollection: Decodable {
    var total: Int
    var total_pages: Int
    var results: [PhotoCollection]
}
