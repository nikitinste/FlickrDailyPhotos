//
//  PageData.swift
//  Flickr Daily Photos
//
//  Created by Степан Никитин on 25.06.2021.
//

import Foundation

enum Pages: CaseIterable {
    case pageZero
    case pageOne
    case pageTwo
    case pageThree
    case pageFour
    case pageFive
    case pageSix
    case pageSeven
    case pageEight
    case pageNine
    
    var index: Int {
        switch self {
        case .pageZero:
            return 0
        case .pageOne:
            return 1
        case .pageTwo:
            return 2
        case .pageThree:
            return 3
        case .pageFour:
            return 4
        case .pageFive:
            return 5
        case .pageSix:
            return 6
        case .pageSeven:
            return 7
        case .pageEight:
            return 8
        case .pageNine:
            return 9
        }
    }
}
