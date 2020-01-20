//
//  RestaurantSortField.swift
//  Restaurants
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import Foundation

public enum RestaurantSortField: String, CaseIterable {
    
    case bestMatch
    case newest
    case ratingAverage
    case distance
    case popularity
    case averageProductPrice
    case deliveryCosts
    case minCost
}

extension RestaurantSortField: CustomStringConvertible {
    
    public var description: String {
        return self.rawValue.camelCaseToWords()
    }
}
