//
//  DateComponents.swift
//  Flickr Daily Photos
//
//  Created by Степан Никитин on 23.06.2021.
//

import Foundation

extension DateComponents {
    static func +(_ lhs: DateComponents, _ rhs: DateComponents) -> DateComponents {
      return combineComponents(lhs, rhs)
    }

    static func -(_ lhs: DateComponents, _ rhs: DateComponents) -> DateComponents {
      return combineComponents(lhs, rhs, multiplier: -1)
    }

    static func combineComponents(_ lhs: DateComponents,
                           _ rhs: DateComponents,
                           multiplier: Int = 1)
      -> DateComponents {
        var result = DateComponents()
        result.nanosecond = (lhs.nanosecond != nil) || (rhs.nanosecond != nil) ? ((lhs.nanosecond ?? 0) + (rhs.nanosecond ?? 0) * multiplier) : nil
        result.second     = (lhs.second != nil)     || (rhs.second != nil)     ? ((lhs.second     ?? 0) + (rhs.second     ?? 0) * multiplier) : nil
        result.minute     = (lhs.minute != nil)     || (rhs.minute != nil)     ? ((lhs.minute     ?? 0) + (rhs.minute     ?? 0) * multiplier) : nil
        result.hour       = (lhs.hour != nil)       || (rhs.hour != nil)       ? ((lhs.hour       ?? 0) + (rhs.hour       ?? 0) * multiplier) : nil
        result.day        = (lhs.day != nil)        || (rhs.day != nil)        ? ((lhs.day        ?? 0) + (rhs.day        ?? 0) * multiplier) : nil
        result.weekOfYear = (lhs.weekOfYear != nil) || (rhs.weekOfYear != nil) ? ((lhs.weekOfYear ?? 0) + (rhs.weekOfYear ?? 0) * multiplier) : nil
        result.month      = (lhs.month != nil)      || (rhs.month != nil)      ? ((lhs.month      ?? 0) + (rhs.month      ?? 0) * multiplier) : nil
        result.year       = (lhs.year != nil)       || (rhs.year != nil)       ? ((lhs.year       ?? 0) + (rhs.year       ?? 0) * multiplier) : nil
        return result
    }
}
