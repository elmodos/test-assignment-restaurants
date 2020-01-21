//
//  String+CamelCaseTests.swift
//  RestaurantsTests
//
//  Created by Modo Ltunzher on 21.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import XCTest
@testable import Restaurants

class StringCamelCaseTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCamelCaseWithSpaces() {
        
        XCTAssertEqual("StringCamelCaseTests".camelCaseToWords(), "String Camel Case Tests")

        XCTAssertEqual("stringCamelCaseTests".camelCaseToWords(), "string Camel Case Tests")

        XCTAssertEqual("UIApplication".camelCaseToWords(), "U I Application")

        XCTAssertEqual("stringcamelcasetests".camelCaseToWords(), "stringcamelcasetests")

        XCTAssertEqual("String Camel Case Tests".camelCaseToWords(), "String Camel Case Tests")

        XCTAssertEqual(" stringCamel Case  Tests ".camelCaseToWords(), " string Camel Case  Tests ")
    }
}
