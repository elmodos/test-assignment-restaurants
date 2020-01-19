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
    
    struct Input {
        let bookmark: Observable<Void>?
    }
    struct Output {
        let name: Driver<String>
        let openStatus: Driver<RestaurantStatus>
        let isBookmarked: Driver<Bool>
    }
    struct Dependencies {
        let model: Restaurant
    }
    private let dependencies: Dependencies
    private let disposeBag = DisposeBag()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func transform(input: Input) -> Output {
        input.bookmark?
            .subscribe(onNext: { _ in
                #warning("TODO")
                print("todo")
            })
            .disposed(by: self.disposeBag)
        
        let model = self.dependencies.model
        let name = Observable.just(model.name)
            .asDriver(onErrorJustReturn: model.name)
        let openStatus = Observable.just(model.status)
            .asDriver(onErrorJustReturn: model.status)
        let isBookmarked = Observable.just(false)
            .asDriver(onErrorJustReturn: false)
        
        return Output(
            name: name,
            openStatus: openStatus,
            isBookmarked: isBookmarked
        )
    }
}
