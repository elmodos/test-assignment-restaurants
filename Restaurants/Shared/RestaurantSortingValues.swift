//
//  RestaurantSortingValues.swift
//  Restaurants
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import Foundation

public protocol RestaurantSortingValues {
    var bestMatch: Float { get }
    var newest: Float { get }
    var ratingAverage: Float { get }
    var distance: Float { get }
    var popularity: Float { get }
    var averageProductPrice: Float { get }
    var deliveryCosts: Float { get }
    var minCost: Float { get }
}
