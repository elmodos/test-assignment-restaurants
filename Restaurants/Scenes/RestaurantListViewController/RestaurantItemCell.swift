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

class RestaurantItemCell: UITableViewCell {
    
    private var viewModel: RestaurantItemViewModel?
    private var reuseDisposeBag = DisposeBag()
    
    @IBOutlet private weak var labelSortOrder: UILabel?
    @IBOutlet private weak var labelTitle: UILabel?
    @IBOutlet private weak var labelOpenStatus: UILabel?
    @IBOutlet private weak var buttonBookmark: UIButton?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.reuseDisposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let labelTitle = self.labelTitle {
            let labelX = self.convert(.zero, from: labelTitle).x
            self.separatorInset = UIEdgeInsets(top: 0, left: labelX, bottom: 0, right: 0)
        }
    }
    
    public func setModel(model: RestaurantItemViewModel?, index: Int) {
        self.viewModel = model
        if let model = self.viewModel {
            self.bindViewModel(model)
        }
        self.labelSortOrder?.text = "\(index)"
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
            output.name.asObservable(),
            output.openStatus.asObservable(),
            output.isBookmarked.asObservable()
        )
            
        observableValues
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { name, openStatus, isBookmarked in
                self.labelTitle?.text = name
                self.labelOpenStatus?.text = openStatus.title
                
                let bookMarkButtonTitle = isBookmarked ? "★" : "☆"
                self.buttonBookmark?.setTitle(bookMarkButtonTitle, for: [])
            })
            .disposed(by: self.reuseDisposeBag)
    }
    
    public static func register(in tableView: UITableView, reuseId: String) {
        let nib = UINib(nibName: "RestaurantItemCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: reuseId)
    }
}
