//
//  RestaurantListModel.swift
//  Restaurants
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import Foundation

class RestaurantListModel: Decodable, Restaurantlist {

    var restaurantModels: [RestaurantModel]
    enum CodingKeys: String, CodingKey {
        case restaurantModels = "restaurants"
    }
    
    var restaurants: [SortableRestaurant] { self.restaurantModels }
}
