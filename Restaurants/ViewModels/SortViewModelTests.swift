//
//  SortViewModelTests.swift
//  RestaurantsTests
//
//  Created by Modo Ltunzher on 21.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
@testable import Restaurants

class SortViewModelTests: XCTestCase {

    let options: [String] = ["option1", "option2", "option3"]
    let initialIndex: Int = 0
    var viewModel: SortViewModel!

    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()

        let dependencies = SortViewModel.Dependencies(options: options, index: initialIndex)
        self.viewModel = SortViewModel(dependencies: dependencies)
    }

    override func tearDown() {
        self.disposeBag = DisposeBag()
    }

    func testIndexFiltering() {
        let observableIndexes = self.scheduler.createColdObservable([
            .next(1, 0),
            .next(2, 1),
            .next(3, 2),
            .next(4, 3),
            .next(5, 100),
            .next(6, -1),
            .next(7, 2)
        ])
        let input = SortViewModel.Input(indexSelected: observableIndexes.asObservable())
        
        let output = self.viewModel.transform(input: input)
        
        let validIndexObserver = self.scheduler.createObserver(Int.self)
        output
            .index
            .asObservable()
            .bind(to: validIndexObserver)
            .disposed(by: self.disposeBag)

        let modelOwnerIndexObserver = self.scheduler.createObserver(Int.self)
        self.viewModel
            .index
            .bind(to: modelOwnerIndexObserver)
            .disposed(by: self.disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(validIndexObserver.events, [
            .next(0, self.initialIndex),
            .next(1, 0),
            .next(2, 1),
            .next(3, 2),
            .next(7, 2)
        ])
        XCTAssertEqual(validIndexObserver.events, modelOwnerIndexObserver.events)
    }
    
    func testOptions() {
        let input = SortViewModel.Input(indexSelected: Observable.empty())
        let output = self.viewModel.transform(input: input)
        XCTAssertEqual(output.options, self.options)
    }

}
