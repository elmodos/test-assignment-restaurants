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
    }

    struct Output {
        let list: Driver<[RestaurantItemViewModel]>
        let showRestaurantDetails: Observable<RestaurantItemViewModel>
    }

    struct Dependencies {
        let model: RestaurantList
    }
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        let mappedList = Observable
            .just(self.dependencies.model.restaurants)
            .map { list -> [RestaurantItemViewModel] in
                return list.map {
                    let dependencies = RestaurantItemViewModel.Dependencies(model: $0)
                    return RestaurantItemViewModel(dependencies: dependencies)
                }
            }
            .asDriver(onErrorJustReturn: [])
        
        let showRestaurantDetails = input
            .itemAtIndexSelected
            .withLatestFrom(mappedList.asObservable()) { (index, list) -> RestaurantItemViewModel in
                list[index]
            }

        return Output(
            list: mappedList,
            showRestaurantDetails: showRestaurantDetails
        )
    }
}
