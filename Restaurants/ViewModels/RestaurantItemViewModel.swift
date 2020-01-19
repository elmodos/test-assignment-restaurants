//
//  RestaurantItemViewModel.swift
//  Restaurants
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RestaurantItemViewModel: ViewModel {
    
    struct Input {}
    struct Output {
        let name: Driver<String>
    }
    struct Dependencies {
        let model: Restaurant
    }
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func transform(input: Input) -> Output {
        let name = Observable.just(self.dependencies.model.name)
            .asDriver(onErrorJustReturn: self.dependencies.model.name)
        return Output(
            name: name
        )
    }
}
