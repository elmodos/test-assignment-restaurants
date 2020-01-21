//
//  RestaurantSortComparator.swift
//  Restaurants
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import Foundation

public struct RestaurantSortComparator {

    // MARK: - Main sorter
    
    public static func sorted(
        _ list: [SortableRestaurant],
        bookmarkStore: AnyBookmarkStore<String>?,
        sortField: RestaurantSortField,
        nameFilter: String
    ) -> [SortableRestaurant] {
        let sortedList = list
            .filter {
                self.isRestaurantIncluded($0, filteredByName: nameFilter)
            }
            .map { restaurant -> (SortableRestaurant, Bool) in
                let isBookmarked = self.isRestaurantBookmarked(restaurant, bookmarkStore: bookmarkStore)
                return (restaurant, isBookmarked)
            }
            .sorted { (lhs, rhs) -> Bool in
                self.compare(lhs.0, rhs.0, lhs.1, rhs.1, sortField)
            }
            .map { $0.0 }
        return sortedList
    }

    // MARK: - Utility functions

    public static func compare(
        lhs: SortableRestaurant,
        rhs: SortableRestaurant,
        lBookmarked: Bool = false,
        rBookmarked: Bool = false,
        sortField: RestaurantSortField
    ) -> Bool {
        return self.compare(lhs, rhs, lBookmarked, rBookmarked, sortField)
    }
    
    public static func compare(
        _ lhs: SortableRestaurant,
        _ rhs: SortableRestaurant,
        _ lBookmarked: Bool,
        _ rBookmarked: Bool,
        _ sortField: RestaurantSortField
    ) -> Bool {
        if lBookmarked != rBookmarked {
            return lBookmarked && !rBookmarked
        }
        if lhs.status != rhs.status {
            return lhs.status < rhs.status
        }
        let lValue = lhs.sortingValues.getFieldValue(sortField)
        let rValue = rhs.sortingValues.getFieldValue(sortField)
        if lValue != rValue {
           return lValue < rValue
        }
        let result = lhs.name.compare(rhs.name, options: .caseInsensitive)
        return result == .orderedAscending
    }
    
    static func isRestaurantIncluded(
        _ restaurant: Restaurant,
        filteredByName nameFilter: String
    ) -> Bool {
        return nameFilter.count == 0
            || restaurant.name.localizedCaseInsensitiveContains(nameFilter)
    }
    
    static func isRestaurantBookmarked(
        _ restaurant: Restaurant,
        bookmarkStore: AnyBookmarkStore<String>?
    ) -> Bool {
        return bookmarkStore?.isBookmarked(restaurant.bookmarkId)
            ?? false
    }
}
