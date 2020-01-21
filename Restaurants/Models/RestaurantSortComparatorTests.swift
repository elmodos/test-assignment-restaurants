//
//  RestaurantSortComparatorTests.swift
//  RestaurantsTests
//
//  Created by Modo Ltunzher on 21.01.2020.
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

class RestaurantSortComparatorTests: XCTestCase {

    typealias Comparator = RestaurantSortComparator

    let twoEqualRertaurants = { () -> (SortableRestaurant, SortableRestaurant) in
        (MockSortableRestaurant(), MockSortableRestaurant())
    }
    
    var mockStore: UserDefaultsBookmarkStore<String>!
    
    override func setUp() {
        let storeKey = "mock_bookmarks"
        let userDefaults = MockUserDefaults(suiteName: #file)!
        userDefaults.key = storeKey
        let store = UserDefaultsBookmarkStore<String>(
            userDefaults: userDefaults,
            key: storeKey
        )
        self.mockStore = store
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIsRestaurantIncluded() {
        let res = MockRestaurant(name: "Abcdefg", status: .unknown)
        
        XCTAssertTrue(Comparator.isRestaurantIncluded(res, filteredByName: ""))
        XCTAssertTrue(Comparator.isRestaurantIncluded(res, filteredByName: "a"))
        XCTAssertTrue(Comparator.isRestaurantIncluded(res, filteredByName: "A"))
        XCTAssertTrue(Comparator.isRestaurantIncluded(res, filteredByName: "cde"))
        XCTAssertTrue(Comparator.isRestaurantIncluded(res, filteredByName: "CDE"))
        XCTAssertTrue(Comparator.isRestaurantIncluded(res, filteredByName: "cDeF"))

        XCTAssertFalse(Comparator.isRestaurantIncluded(res, filteredByName: "z"))
        XCTAssertFalse(Comparator.isRestaurantIncluded(res, filteredByName: "Abcdefgh"))
        XCTAssertFalse(Comparator.isRestaurantIncluded(res, filteredByName: "zAbcdefg"))
        
        let cyrres = MockRestaurant(name: "Жщшюїя", status: .unknown)
        
        XCTAssertTrue(Comparator.isRestaurantIncluded(cyrres, filteredByName: ""))
        XCTAssertTrue(Comparator.isRestaurantIncluded(cyrres, filteredByName: "ж"))
        XCTAssertTrue(Comparator.isRestaurantIncluded(cyrres, filteredByName: "Щш"))

        XCTAssertFalse(Comparator.isRestaurantIncluded(cyrres, filteredByName: "z"))
    }
    
    func testIsRestaurantBookmarked() {
        var res = MockRestaurant(name: "1", status: .unknown)
        XCTAssertTrue(Comparator.isRestaurantBookmarked(res, bookmarkStore: self.mockStore))

        res = MockRestaurant(name: "", status: .unknown)
        XCTAssertFalse(Comparator.isRestaurantBookmarked(res, bookmarkStore: self.mockStore))

        res = MockRestaurant(name: "w", status: .unknown)
        XCTAssertFalse(Comparator.isRestaurantBookmarked(res, bookmarkStore: self.mockStore))
    }
    
    func testComparatoreByBookmarked() {
        var (res1, res2) = twoEqualRertaurants()
        var isHigherInList = Comparator.compare(
            lhs: res1,
            rhs: res2,
            lBookmarked: true,
            rBookmarked: false,
            sortField: .averageProductPrice
        )
        XCTAssert(isHigherInList == true)
        
        (res1, res2) = twoEqualRertaurants()
        isHigherInList = Comparator.compare(
            lhs: res1,
            rhs: res2,
            lBookmarked: false,
            rBookmarked: true,
            sortField: .averageProductPrice
        )
        XCTAssert(isHigherInList == false)
    }
    
    func testComparatoreByStatus() {
        let list: [(RestaurantStatus, RestaurantStatus, Bool)] = [
            
            (.open, .orderAhead, true),
            (.open, .closed, true),
            (.orderAhead, .closed, true),

            (.closed, .orderAhead, false),
            (.closed, .open, false),
            (.orderAhead, .open, false)
        ]
        
        list.forEach { (status1, status2, isHigherInList) in
            var res1 = MockSortableRestaurant()
            var res2 = MockSortableRestaurant()
            res1.status = status1
            res2.status = status2
            let result = Comparator.compare(lhs: res1, rhs: res2, sortField: .bestMatch)
            XCTAssert(isHigherInList == result, "(\(status1) < \(status2)) should be \(isHigherInList)")
        }
    }
    
    func makeSixMockRestaurants() -> [SortableRestaurant] {
        var list = [
            MockSortableRestaurant(),
            MockSortableRestaurant(),
            MockSortableRestaurant(),
            MockSortableRestaurant(),
            MockSortableRestaurant(),
            MockSortableRestaurant()
        ]
        list[0].name = "4"
        list[1].name = "5"
        list[5].name = ""
        list[2].name = "3"
        list[3].name = "2"
        list[4].name = "1"
        return list
    }
    
    func testSortedEqualBookmarked() {
        let list = self.makeSixMockRestaurants()
        let result = Comparator.sorted(list, bookmarkStore: nil, sortField: .newest, nameFilter: "")
        XCTAssertEqual(result.count, 6)

        let sortedNames = result.map { $0.name }
        XCTAssertEqual(sortedNames, ["", "1", "2", "3", "4", "5"])
    }

    func testSortedMockedBookmarked() {
        let list = self.makeSixMockRestaurants()
        let result = Comparator.sorted(list, bookmarkStore: self.mockStore, sortField: .newest, nameFilter: "")
        XCTAssertEqual(result.count, 6)
        let sortedNames = result.map { $0.name }
        XCTAssertEqual(sortedNames, ["1", "2", "3", "", "4", "5"])
    }
    
    func testFilterByName() {
        var list = self.makeSixMockRestaurants()
        list.append(contentsOf: self.makeSixMockRestaurants()) // 12 restaurants
        
        let result = Comparator.sorted(list, bookmarkStore: nil, sortField: .newest, nameFilter: "2")
        XCTAssertEqual(result.count, 2)
        let sortedNames = result.map { $0.name }
        XCTAssertEqual(sortedNames, ["2", "2"])
    }
}
