//
//  Photo.swift
//  Clone-UnsplashApp
//
//  Created by admin on 3/23/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

struct DetailPhoto: Decodable {
    var id: String
    var user: User
    var urls: PhotoType
    var likes: Int
    var views: Int
    var downloads: Int
//    var width: Int
//    var height: Int
}

struct PhotoType: Decodable {
    var raw: String
    var full: String
    var regular: String
    var small: String
    var thumb: String
}

//Search Photo
struct SearchPhoto: Decodable {
    var total: Int
    var total_pages: Int
    var results: [PhotoList]
}

//Photo List
struct PhotoList: Decodable {
    var id: String
    var urls: PhotoType
    var width: Int
    var height: Int
}
