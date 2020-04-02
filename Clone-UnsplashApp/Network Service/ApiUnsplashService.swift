//
//  ApiUnsplash.swift
//  Clone-UnsplashApp
//
//  Created by admin on 3/23/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import Moya

public let clientID: String = "h4bjGoxqMg5I_QhAxF2z9kzq-iWr2zdolsVPrbCqNfY" // <- AccessKey

enum ApiUnsplashService {
    case getListPhoto(clientID: String, page: Int)
    case getListPhotoCollection(clientID: String, page: Int)
    case getDetailPhoto(photoID: String, clientID: String)
    case getDetailPhotoCollection(collectionPhotoID: Int, clientID: String, page: Int)
    
    case searchPhoto(query: String, clientID: String, page: Int)
    case searchPhotoCollection(query: String, clientID: String, page: Int)
}

extension ApiUnsplashService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.unsplash.com")!
    }
    
    var path: String {
        switch self {
        case .getListPhoto(_, _):
            return "/photos"
        case .getListPhotoCollection(_, _):
            return "/collections"
        case .getDetailPhoto(let photoID, _):
            return "/photos/\(photoID)"
        case .getDetailPhotoCollection(let collectionPhotoID, _, _):
            return "/collections/\(collectionPhotoID)/photos"
        case .searchPhoto(_, _, _):
            return "/search/photos"
        case .searchPhotoCollection(_, _, _):
            return "/search/collections"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getListPhoto(_, _),
             .getListPhotoCollection(_, _),
             .getDetailPhoto(_, _),
             .getDetailPhotoCollection(_, _, _),
             .searchPhoto(_, _, _),
             .searchPhotoCollection(_, _, _):
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getListPhoto(let clientID, let page):
            return "\(clientID), \(page)".data(using: .utf8)!
        case .getListPhotoCollection(let clientID, let page):
            return "\(clientID), \(page)".data(using: .utf8)!
        case .getDetailPhoto(let photoID, let clientID):
            return "\(photoID), \(clientID)".data(using: .utf8)!
        case .getDetailPhotoCollection(let collectionPhotoID, let clientID, let page):
            return "\(collectionPhotoID), \(clientID), \(page)".data(using: .utf8)!
        case .searchPhoto(let query, let clientID, let page):
            return "\(query), \(clientID), \(page)".data(using: .utf8)!
        case .searchPhotoCollection(let query, let clientID, let page):
            return "\(query), \(clientID), \(page)".data(using: .utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .getListPhoto(let clientID, let page):
            return .requestParameters(parameters: ["client_id" : "\(clientID)", "page" : "\(page)"], encoding: URLEncoding.default)
        case .getListPhotoCollection(let clientID, let page):
            return .requestParameters(parameters: ["client_id" : "\(clientID)", "page" : "\(page)"], encoding: URLEncoding.default)
        case .getDetailPhoto(_, let clientID):
            return .requestParameters(parameters: ["client_id" : "\(clientID)"], encoding: URLEncoding.default)
        case .getDetailPhotoCollection(_, let clientID, let page):
            return .requestParameters(parameters: ["client_id" : "\(clientID)", "page" : "\(page)"], encoding: URLEncoding.default)
        case .searchPhoto(let query, let clientID, let page):
            return .requestParameters(parameters: ["query" : "\(query)", "client_id" : "\(clientID)", "page" : "\(page)"], encoding: URLEncoding.default)
        case .searchPhotoCollection(let query, let clientID, let page):
            return .requestParameters(parameters: ["query" : "\(query)", "client_id" : "\(clientID)", "page" : "\(page)"], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    
}
