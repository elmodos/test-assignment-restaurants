//
//  RestaurantSortingValuesModelTests.swift
//  RestaurantsTests
//
//  Created by Modo Ltunzher on 21.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import XCTest
@testable import Restaurants

class RestaurantSortingValuesModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecodable() {
        let sampleJson = """
        {
            "bestMatch": 0.0,
            "newest": 96.0,
            "ratingAverage": 4.5,
            "distance": 1190,
            "popularity": 17.0,
            "averageProductPrice": 1536,
            "deliveryCosts": 200,
            "minCost": 1000,
            "some_extra_field": 0
        }
        """
        do {
            let data = sampleJson.data(using: .utf8)!
            let sort = try JSONDecoder().decode(RestaurantSortingValuesModel.self, from: data)
            let allEqual = { (params: Float...) -> Bool in
                let value = params[0]
                return params.allSatisfy { $0.isEqual(to: value) }
            }
            XCTAssertTrue(allEqual(sort.bestMatch, 0.0))
            XCTAssertTrue(allEqual(sort.newest, 96.0))
            XCTAssertTrue(allEqual(sort.ratingAverage, 4.5))
            XCTAssertTrue(allEqual(sort.distance, 1190))
            XCTAssertTrue(allEqual(sort.popularity, 17.0))
            XCTAssertTrue(allEqual(sort.averageProductPrice, 1536))
            XCTAssertTrue(allEqual(sort.deliveryCosts, 200))
            XCTAssertTrue(allEqual(sort.minCost, 1000))
        } catch {
            XCTFail("\(error.localizedDescription)")
        }
    }
}
