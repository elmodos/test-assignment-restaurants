//
//  RestaurantModelTests.swift
//  RestaurantsTests
//
//  Created by Modo Ltunzher on 21.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import XCTest
@testable import Restaurants

class RestaurantModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecodable() {
        let sampleJson = self.composeSampleJson()
        do {
            let data = sampleJson.data(using: .utf8)!
            let restaurant = try JSONDecoder().decode(RestaurantModel.self, from: data)

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
    
    func testStatus() {
        let getParsedStatus = { (status: String) throws -> RestaurantStatus in
            let sampleJson = self.composeSampleJson(status: status)
            let data = sampleJson.data(using: .utf8)!
            let restaurant = try JSONDecoder().decode(RestaurantModel.self, from: data)
            return restaurant.status
        }
        
        do {
            // valid
            var status = try getParsedStatus("open")
            XCTAssertEqual(status, .open)

            status = try getParsedStatus("order ahead")
            XCTAssertEqual(status, .orderAhead)
            
            status = try getParsedStatus("closed")
            XCTAssertEqual(status, .closed)
            
            // not valid
            status = try getParsedStatus("Open")
            XCTAssertEqual(status, .unknown)
            status = try getParsedStatus("Closed")
            XCTAssertEqual(status, .unknown)
            status = try getParsedStatus("orderAhead")
            XCTAssertEqual(status, .unknown)
            status = try getParsedStatus("Order Ahead")
            XCTAssertEqual(status, .unknown)
        } catch {
            XCTFail("\(error.localizedDescription)")
        }
    }
    
    func composeSampleJson(status: String = "open") -> String {
        let sampleJson = """
        {
            "name": "Tanoshii Sushi",
            "status": "\(status)",
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
        }
        """
        return sampleJson
    }
}
