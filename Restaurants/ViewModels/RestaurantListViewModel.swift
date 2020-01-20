//
//  RestaurantListViewModel.swift
//  Restaurants
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RestaurantListViewModel: ViewModel {
    
    struct Input {
        let itemAtIndexSelected: Observable<Int>
        let sortTapped: Observable<Void>
    }

    struct Output {
        let list: Driver<[RestaurantItemViewModel]>
        let showRestaurantDetails: Observable<RestaurantItemViewModel>
        let showSortOptions: Observable<SortViewModel>
    }

    struct Dependencies {
        let model: RestaurantList
        let bookmarkStore: AnyBookmarkStore<String>?
        let initialSortValue: RestaurantSortField
    }
    private let dependencies: Dependencies
    public var currentSortField: RestaurantSortField { self.sortField.value }
    private lazy var sortField =
        BehaviorRelay<RestaurantSortField>(value: self.dependencies.initialSortValue)
    // TODO: filter value here
    let disposeBag = DisposeBag()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        let bookmarkStore = self.dependencies.bookmarkStore
        let mappedList = Observable
            .just(self.dependencies.model.restaurants)
            .map { list -> [RestaurantItemViewModel] in
                return list.map {
                    let dependencies = RestaurantItemViewModel.Dependencies(
                        model: $0,
                        bookmarkStore: bookmarkStore
                    )
                    return RestaurantItemViewModel(dependencies: dependencies)
                }
            }
            .asDriver(onErrorJustReturn: [])
        
        let showRestaurantDetails = input
            .itemAtIndexSelected
            .withLatestFrom(mappedList.asObservable()) { (index, list) -> RestaurantItemViewModel in
                list[index]
            }

        let showSortOptions = input.sortTapped
            .compactMap { [weak self] _ -> SortViewModel? in
                return self?.createRestaurantsSortViewModel(current: self!.sortField.value)
            }

        return Output(
            list: mappedList,
            showRestaurantDetails: showRestaurantDetails
            showSortOptions: showSortOptions
    
    func createRestaurantsSortViewModel(current: RestaurantSortField) -> SortViewModel {
        let allOptions = RestaurantSortField.allCases
        let index = allOptions.firstIndex(of: current) ?? -1
        let optionNames = allOptions.map { $0.description }
        let dependencies = SortViewModel.Dependencies(
            options: optionNames,
            index: index
        )
        let sortModel = SortViewModel(dependencies: dependencies)
        sortModel
            .index
            .map { allOptions[$0] }
            .bind(to: self.sortField)
            .disposed(by: sortModel.disposeBag)
        return sortModel
    }
}
