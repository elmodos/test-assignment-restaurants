//
//  UserDefaultsBookmarkStoreTests.swift
//  RestaurantsTests
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import XCTest
@testable import Restaurants

class UserDefaultsBookmarkStoreTests: XCTestCase {

    let suitName = "test." + #file // don't treat suite name as file path
    var store: UserDefaultsBookmarkStore<String>!
    let key1 = "bookmark1"
    let key2 = "bookmark2"

    override func setUp() {
        store = UserDefaultsBookmarkStore<String>(suiteName: suitName)!
    }

    override func tearDown() {
        UserDefaults().removePersistentDomain(forName: self.suitName)
    }

    func testStrings() {
        XCTAssertFalse(store.isBookmarked(key1))
        XCTAssertFalse(store.isBookmarked(key2))

        store.setBookmarked(true, element: key1)
        XCTAssertTrue(store.isBookmarked(key1))
        XCTAssertFalse(store.isBookmarked(key2))

        // don't loose existing
        store.setBookmarked(true, element: key2)
        XCTAssertTrue(store.isBookmarked(key1))
        XCTAssertTrue(store.isBookmarked(key2))

        // repeaded add
        store.setBookmarked(true, element: key1)
        store.setBookmarked(true, element: key1)
        store.setBookmarked(false, element: key2)
        store.setBookmarked(false, element: key1)
        XCTAssertFalse(store.isBookmarked(key1))
        XCTAssertFalse(store.isBookmarked(key2))

        store.setBookmarked(true, element: key1)
        store.setBookmarked(true, element: key2)
        let paralelStore = UserDefaultsBookmarkStore<String>(suiteName: suitName)!
        XCTAssertTrue(paralelStore.isBookmarked(key1))
        XCTAssertTrue(paralelStore.isBookmarked(key2))
    }
}
