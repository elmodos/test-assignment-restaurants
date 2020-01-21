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
        let restaurant: Driver<SortableRestaurant>
        let isBookmarked: Driver<Bool>
    }
    struct Dependencies {
        let model: SortableRestaurant
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
        var bookmarkStore = self.dependencies.bookmarkStore
        let bookmarkElement = self.dependencies.model.bookmarkId
            
        input.bookmark?
            .subscribe(onNext: { _ in
                bookmarkStore?.toggle(for: bookmarkElement)
            })
            .disposed(by: self.disposeBag)
        
        let model = self.dependencies.model
        let restaurant = BehaviorRelay<SortableRestaurant>(value: model).asDriver()
        let isBookmarked = self.bookmarkedSubject.asDriver()
        
        return Output(
            restaurant: restaurant,
            isBookmarked: isBookmarked
        )
    }
    
    func isBookmarked() -> Bool {
        let element = self.dependencies.model.bookmarkId
        return self.dependencies.bookmarkStore?.isBookmarked(element)
            ?? false
    }
}
