//
//  RestaurantStatus.swift
//  Restaurants
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import Foundation

public enum RestaurantStatus: String, CaseIterable {
    // By priority
    case open = "open"
    case orderAhead = "order ahead"
    case closed = "closed"
    case unknown = "unknown"
}

extension RestaurantStatus {
    var title: String { self.rawValue }
}

extension RestaurantStatus: Comparable {
    
    public static func < (lhs: RestaurantStatus, rhs: RestaurantStatus) -> Bool {
        let all = self.allCases
        if let lIndex = all.firstIndex(of: lhs),
            let rIndex = all.firstIndex(of: rhs),
            lIndex < rIndex {
            return true
        }
        return false
    }
}
