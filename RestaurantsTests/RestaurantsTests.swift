//
//  RestaurantsTests.swift
//  RestaurantsTests
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import XCTest
@testable import Restaurants

internal struct MockRestaurant: Restaurant {
    var name: String = ""
    var status: RestaurantStatus = .unknown
}

internal struct MockSortingValues: RestaurantSortingValues {
    var bestMatch: Float = 0
    var newest: Float = 0
    var ratingAverage: Float = 0
    var distance: Float = 0
    var popularity: Float = 0
    var averageProductPrice: Float = 0
    var deliveryCosts: Float = 0
    var minCost: Float = 0
}

internal struct MockSortableRestaurant: SortableRestaurant {
    var sortingValues: RestaurantSortingValues = MockSortingValues()
    var name: String = ""
    var status: RestaurantStatus = .unknown
}

class MockUserDefaults: UserDefaults {
    var key: String = "bookmarks"
    override func array(forKey defaultName: String) -> [Any]? {
        if defaultName == key {
            return ["1", "2", "3"]
        }
        return super.array(forKey: defaultName)
    }
}

class RestaurantsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
