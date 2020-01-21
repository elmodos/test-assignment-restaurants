//
//  RestaurantListModelTests.swift
//  RestaurantsTests
//
//  Created by Modo Ltunzher on 21.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import XCTest
@testable import Restaurants

class RestaurantListModelTests: XCTestCase {

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
            let loadedList = try self.tryDecode(json: sampleJson)
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
    
    func testEmptyList() {
        let sampleJson = """
        { "restaurants": [] }
        """
        do {
            let loadedList = try self.tryDecode(json: sampleJson)
            XCTAssertEqual(loadedList.restaurants.count, 0)

        } catch {
            XCTFail("\(error.localizedDescription)")
        }
    }

    func testEmptyJson() {
        let sampleJson = "{}"
        XCTAssertThrowsError(try self.tryDecode(json: sampleJson))
    }

    func testUnschemmedJson() {
        let sampleJson = """
        {
            "restaurants": [
                {
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
                },
                {
                    "name": "Invalid",
                    "status": "open",
                    "sortingValues": {
                        "bestMatch_": 0.0,
                        "newest": 96.0,
                        "ratingAverage": 4.5,
                        "distance": 1190,
                        "popularity": 17.0,
                        "averageProductPrice": 1536,
                        "deliveryCosts": 200,
                        "minCost": 1000
                    }
                }
            ]
        }
        """
        XCTAssertThrowsError(try self.tryDecode(json: sampleJson))
    }

    func tryDecode(json: String) throws -> RestaurantListModel {
        let data = json.data(using: .utf8)!
        let model = try JSONDecoder().decode(RestaurantListModel.self, from: data)
        return model
    }
}
