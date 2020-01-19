//
//  RestaurantSortingValuesModel.swift
//  Restaurants
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import Foundation

class RestaurantSortingValuesModel: Decodable, RestaurantSortingValues {
    
    let bestMatch: Float
    let newest: Float
    let ratingAverage: Float
    let distance: Float
    let popularity: Float
    let averageProductPrice: Float
    let deliveryCosts: Float
    let minCost: Float
}
