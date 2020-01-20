//
//  SortViewModel.swift
//  Restaurants
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SortViewModel: ViewModel {
    
    struct Input {
        let indexSelected: Observable<Int>
    }
    
    struct Output {
        let options: [String]
        let index: Driver<Int>
    }
    
    struct Dependencies {
        let options: [String]
        let index: Int
    }
    private let dependencies: Dependencies
    
    public var index: Observable<Int> {
        self.indexRelay.asObservable()
    }
    
    private lazy var indexRelay = BehaviorRelay<Int>(value: self.dependencies.index)
    let disposeBag = DisposeBag()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func transform(input: Input) -> Output {
        
        let optionsList = self.dependencies.options
        let optionsCount = optionsList.count
        
        input.indexSelected
            .filter { 0...optionsCount-1 ~= $0 }
            .do(onNext: { print("New sort index: \($0)" )})
            .bind(to: self.indexRelay)
            .disposed(by: self.disposeBag)
        
        let index = self.indexRelay.asDriver()
        return Output(
            options: optionsList,
            index: index
        )
    }
}
