//
//  RestaurantModel.swift
//  Restaurants
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import Foundation

class RestaurantModel: Decodable, SortableRestaurant {
    
    let name: String
    let statusString: String
    let sortingValuesModel: RestaurantSortingValuesModel
    
    enum CodingKeys: String, CodingKey {
        case name
        case statusString = "status"
        case sortingValuesModel = "sortingValues"
    }
    
    private(set) lazy var status: RestaurantStatus = {
        RestaurantStatus(rawValue: self.statusString) ?? .unknown
    }()
    
    var sortingValues: RestaurantSortingValues { self.sortingValuesModel }
}
