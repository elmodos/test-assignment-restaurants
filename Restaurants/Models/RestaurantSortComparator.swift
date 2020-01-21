//
//  RestaurantSortComparator.swift
//  Restaurants
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import Foundation

public struct RestaurantSortComparator {
    
    public static func compare(
        _ lhs: SortableRestaurant,
        _ rhs: SortableRestaurant,
        _ lBookmarked: Bool,
        _ rBookmarked: Bool,
        sortField: RestaurantSortField
    ) -> Bool {
        if lBookmarked != rBookmarked {
            return lBookmarked && !rBookmarked
        }
        if lhs.status != rhs.status {
            return lhs.status < rhs.status
        }        
        let lValue = lhs.sortingValues.getFieldValue(sortField)
        let rValue = rhs.sortingValues.getFieldValue(sortField)
        return lValue < rValue
    }
    
    public static func sorted(
        _ list: [SortableRestaurant],
        bookmarkStore: AnyBookmarkStore<String>?,
        sortField: RestaurantSortField,
        nameFilter: String
    ) -> [SortableRestaurant] {
        let listWithBookmarks = list
            .filter {
                nameFilter.count == 0 || $0.name.localizedCaseInsensitiveContains(nameFilter)                
            }
            .map { restaurant -> (SortableRestaurant, Bool) in
                let isBookmarked: Bool = bookmarkStore?.isBookmarked(restaurant.bookmarkId)
                    ?? false
                return (restaurant, isBookmarked)
            }
        let sortedList = listWithBookmarks.sorted { (lhs, rhs) -> Bool in
                self.compare(lhs.0, rhs.0, lhs.1, rhs.1, sortField: sortField)
            }
            .map { $0.0 }
        print("Before sort: \(list.map { $0.name })")
        print("After sort: \(sortedList.map { $0.name })")
        return sortedList
    }
}
