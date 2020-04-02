//
//  User.swift
//  Clone-UnsplashApp
//
//  Created by admin on 3/23/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

struct User: Decodable {
    var id: String
    var username: String
    var profile_image: UserProfileImageType
}

struct UserProfileImageType: Decodable {
    var small: String
    var medium: String
    var large: String
}
