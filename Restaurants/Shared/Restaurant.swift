//
//  Restaurant.swift
//  Restaurants
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import Foundation

public protocol Restaurant {
    var name: String { get }
    var status: RestaurantStatus { get }
}

public protocol SortableRestaurant: Restaurant {
    var sortingValues: RestaurantSortingValues { get }
}

public protocol RestaurantList {
    var restaurants: [SortableRestaurant] { get }
}
