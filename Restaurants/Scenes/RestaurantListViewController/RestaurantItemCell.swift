//
//  RestaurantItemCell.swift
//  Restaurants
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

fileprivate extension RestaurantStatus {
    
    func toColor() -> UIColor {
        switch self {
        case .open: return .systemGreen
        case .orderAhead: return .systemOrange
        case .closed: return .systemRed
        case .unknown: return .secondaryLabel
        }
    }
}

class RestaurantItemCell: UITableViewCell {
    
    private var viewModel: RestaurantItemViewModel?
    private var reuseDisposeBag = DisposeBag()
    
    @IBOutlet private weak var labelTitle: UILabel?
    @IBOutlet private weak var labelOpenStatus: UILabel?
    @IBOutlet private weak var labelSortValue: UILabel?
    @IBOutlet private weak var buttonBookmark: UIButton?
    
    var sortField: RestaurantSortField? = nil
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.sortField = nil
        self.reuseDisposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let labelTitle = self.labelTitle {
            let labelX = self.convert(.zero, from: labelTitle).x
            self.separatorInset = UIEdgeInsets(top: 0, left: labelX, bottom: 0, right: 0)
        }
    }
    
    public func setModel(model: RestaurantItemViewModel?, sortField: RestaurantSortField) {
        self.viewModel = model
        self.sortField = sortField
        if let model = self.viewModel {
            self.bindViewModel(model)
        }
    }
    
    private func bindViewModel(_ model: RestaurantItemViewModel) {
        let bookmarkEventUntilReused = Observable<Void>.create { [weak self] observer in
            self?.buttonBookmark?.rx
                .tap
                .bind(to: observer)
                .disposed(by: self!.reuseDisposeBag)
            return Disposables.create()
        }
        let input = RestaurantItemViewModel.Input(
            bookmark: bookmarkEventUntilReused
        )
        let output = model.transform(input: input)
        
        let observableValues = Observable.combineLatest(
            output.restaurant.asObservable(),
            output.isBookmarked.asObservable()
        )
            
        observableValues
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] restaurant, isBookmarked in
                self?.load(restaurant: restaurant, isBookmarked: isBookmarked)
            })
            .disposed(by: self.reuseDisposeBag)
    }
    
    public static func register(in tableView: UITableView, reuseId: String) {
        let nib = UINib(nibName: "RestaurantItemCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: reuseId)
    }
    
    private func load(restaurant: SortableRestaurant, isBookmarked: Bool) {
        self.labelTitle?.text = restaurant.name
        self.labelOpenStatus?.text = restaurant.status.title
        self.labelOpenStatus?.textColor = restaurant.status.toColor()
        
        if let sortField = self.sortField {
            let value = restaurant.sortingValues.getFieldValue(sortField)
            self.labelSortValue?.text = "\(sortField.description): \(value)"
        } else {
            self.labelSortValue?.text = nil
        }
        
        let bookMarkButtonTitle = isBookmarked ? "★" : "☆"
        self.buttonBookmark?.setTitle(bookMarkButtonTitle, for: [])
    }
}
