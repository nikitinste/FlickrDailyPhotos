//
//  GalleryInfo.swift
//  Flickr Daily Photos
//
//  Created by Степан Никитин on 23.06.2021.
//

import Foundation

struct PhotoInfo: Codable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let title: String
    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case owner
//        case secret
//        case server
//        case title
//    }
}

struct GalleryInfo: Codable {
    let photos: [PhotoInfo]
    
    enum CodingKeys: String, CodingKey {
        case photos = "photo"
    }
}

struct GalleryResponse: Codable {
    let gallery: GalleryInfo
    
    enum CodingKeys: String, CodingKey {
        case gallery = "photos"
    }
}
