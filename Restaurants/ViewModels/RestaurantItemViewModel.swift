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
        let bookmarkStore: AnyBookmarkStore<String>?
    }
    private let dependencies: Dependencies
    private let disposeBag = DisposeBag()
    
    private lazy var bookmarkedSubject = BehaviorRelay<Bool>(value: self.isBookmarked())
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.dependencies.bookmarkStore?
            .bookmarksChanged
            .subscribe(onNext: { [weak self] _ in
                self?.bookmarkedSubject.accept(self!.isBookmarked())
            })
            .disposed(by: self.disposeBag)
    }

    func transform(input: Input) -> Output {
        let bookmarkStore = self.dependencies.bookmarkStore
        let bookmarkElement = self.dependencies.model.name
            
        input.bookmark?
            .subscribe(onNext: { _ in
                bookmarkStore?.toggle(for: bookmarkElement)
            })
            .disposed(by: self.disposeBag)
        
        let model = self.dependencies.model
        let name = Observable.just(model.name)
            .asDriver(onErrorJustReturn: model.name)
        let openStatus = Observable.just(model.status)
            .asDriver(onErrorJustReturn: model.status)
        let isBookmarked = self.bookmarkedSubject.asDriver()
        
        return Output(
            name: name,
            openStatus: openStatus,
            isBookmarked: isBookmarked
        )
    }
    
    func isBookmarked() -> Bool {
        let element = self.dependencies.model.name
        return self.dependencies.bookmarkStore?.isBookmarked(element)
            ?? false
    }
}
