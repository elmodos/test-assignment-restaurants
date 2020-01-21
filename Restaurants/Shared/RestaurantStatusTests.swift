//
//  RestaurantStatusTests.swift
//  RestaurantsTests
//
//  Created by Modo Ltunzher on 21.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import XCTest
@testable import Restaurants

class RestaurantStatusTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testComparable() {
        
        XCTAssertLessThan(RestaurantStatus.open, RestaurantStatus.orderAhead)
        XCTAssertLessThan(RestaurantStatus.orderAhead, RestaurantStatus.closed)
        XCTAssertLessThan(RestaurantStatus.closed, RestaurantStatus.unknown)

        XCTAssertGreaterThan(RestaurantStatus.orderAhead, RestaurantStatus.open)
        XCTAssertGreaterThan(RestaurantStatus.closed, RestaurantStatus.orderAhead)
        XCTAssertGreaterThan(RestaurantStatus.unknown, RestaurantStatus.closed)
    }
}
