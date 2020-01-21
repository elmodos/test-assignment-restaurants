//
//  RestaurantItemViewModelTests.swift
//  RestaurantsTests
//
//  Created by Modo Ltunzher on 21.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import Restaurants

class RestaurantItemViewModelTests: XCTestCase {

    var viewModel: RestaurantItemViewModel!
    var mockStore: UserDefaultsBookmarkStore<String>!

    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()

        let storeKey = "mock_bookmarks"
        let suiteName = "mock." + #file
        let userDefaults = UserDefaults(suiteName: suiteName)!
        userDefaults.removePersistentDomain(forName: suiteName) // if any
        let store = UserDefaultsBookmarkStore<String>(
            userDefaults: userDefaults,
            key: storeKey
        )
        store.synchronizeToFile = false
        self.mockStore = store

        var restaurant = MockSortableRestaurant()
        restaurant.name = "name"
        restaurant.status = .closed
        let dependencies = RestaurantItemViewModel.Dependencies(model: restaurant, bookmarkStore: mockStore)
        self.viewModel = RestaurantItemViewModel(dependencies: dependencies)
    }

    override func tearDown() {
        self.disposeBag = DisposeBag()
    }

    func testExample() {
        let bookmarkTaps = self.scheduler.createColdObservable([
            .next(1, ()),
            .next(2, ()),
            .next(4, ())
        ])
        let input = RestaurantItemViewModel.Input(bookmark: bookmarkTaps.asObservable())
        let output = self.viewModel.transform(input: input)
        
        let bookmarkObserver = self.scheduler.createObserver(Bool.self)
        output.isBookmarked
            .asObservable()
            .bind(to: bookmarkObserver)
            .disposed(by: self.disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(bookmarkObserver.events, [
            .next(0, false), // initially not bookmarked
            .next(1, true),
            .next(2, false),
            .next(4, true)
        ])
    }
}
