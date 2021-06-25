//
//  GalleryData.swift
//  Flickr Daily Photos
//
//  Created by Степан Никитин on 22.06.2021.
//

import Foundation
import UIKit

struct GalleryData {
    var date: String
    var images: [UIImage?] = Array.init(repeating: nil, count: 10)
    var titles: [String]?
    var imageURLs: [URL]?
}
