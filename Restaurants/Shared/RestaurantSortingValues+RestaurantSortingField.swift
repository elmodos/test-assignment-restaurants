//
//  RestaurantSortingValues+RestaurantSortingField.swift
//  Restaurants
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import Foundation

extension RestaurantSortingValues {
    
    public func getFieldValue(_ field: RestaurantSortField) -> Float {
        switch field {
        case .bestMatch: return self.bestMatch
        case .newest: return self.newest
        case .ratingAverage: return self.ratingAverage
        case .distance: return self.distance
        case .popularity: return self.popularity
        case .averageProductPrice: return self.averageProductPrice
        case .deliveryCosts: return self.deliveryCosts
        case .minCost: return self.minCost
        }
    }
}
