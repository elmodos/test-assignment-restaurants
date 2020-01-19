//
//  RestaurantListLoaderTests.swift
//  RestaurantsTests
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import XCTest
@testable import Restaurants

class RestaurantListLoaderTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadFromData() {
        let sampleJson = """
        {
            "restaurants": [{
                "name": "Tanoshii Sushi",
                "status": "open",
                "sortingValues": {
                    "bestMatch": 0.0,
                    "newest": 96.0,
                    "ratingAverage": 4.5,
                    "distance": 1190,
                    "popularity": 17.0,
                    "averageProductPrice": 1536,
                    "deliveryCosts": 200,
                    "minCost": 1000
                }
            }]
        }
        """
        do {
            let data = sampleJson.data(using: .utf8)!
            let loadedList = try RestaurantListLoader.load(from: data)
            XCTAssertEqual(loadedList.restaurants.count, 1)

            let restaurant = loadedList.restaurants[0]
            XCTAssertEqual(restaurant.name, "Tanoshii Sushi")
            XCTAssertEqual(restaurant.status, .open)
            
            let sort = restaurant.sortingValues
            XCTAssertEqual(sort.bestMatch, 0.0)
            XCTAssertEqual(sort.newest, 96.0)
            XCTAssertEqual(sort.ratingAverage, 4.5)
            XCTAssertEqual(sort.distance, 1190)
            XCTAssertEqual(sort.popularity, 17.0)
            XCTAssertEqual(sort.averageProductPrice, 1536)
            XCTAssertEqual(sort.deliveryCosts, 200)
            XCTAssertEqual(sort.minCost, 1000)
        } catch {
            XCTFail("\(error.localizedDescription)")
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
