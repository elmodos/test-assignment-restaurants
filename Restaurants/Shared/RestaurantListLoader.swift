//
//  RestaurantListLoader.swift
//  Restaurants
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import Foundation

public struct RestaurantListLoader {
    
    public static func load(from data: Data) throws -> RestaurantList {
        let restaurants: RestaurantList = try JSONDecoder().decode(RestaurantListModel.self, from: data)
        return restaurants
    }
}
