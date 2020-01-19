//
//  RestaurantListViewController.swift
//  Restaurants
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RestaurantListViewController: UITableViewController {

    let viewModel: RestaurantListViewModel
    let cellId = "cell"
    let disposeBag = DisposeBag()
    lazy var buttonItemSort = UIBarButtonItem(title: "Sort", style: .plain, target: nil, action: nil)

    init(viewModel: RestaurantListViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
        self.title = "Restaurants"
        self.navigationItem.rightBarButtonItem = self.buttonItemSort
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RestaurantItemCell.register(in: self.tableView, reuseId: self.cellId)
        self.bindModel(self.viewModel)
    }

    private func bindModel(_ model: RestaurantListViewModel) {
        // exposing events
        let itemAtIndexSelected = self.tableView.rx
            .itemSelected
            .do(onNext: { [weak self] in
                self?.tableView.deselectRow(at: $0, animated: true)
            })
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { $0.row }

        let input = RestaurantListViewModel.Input(
            itemAtIndexSelected: itemAtIndexSelected
        )
        
        // consuming
        let output = self.viewModel.transform(input: input)

        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        output.list
            .asObservable()
            .bind(to: self.tableView.rx.items(cellIdentifier: "cell")) { row, model, cell in
                (cell as? RestaurantItemCell)?.setModel(model: model, index: row + 1)
            }
            .disposed(by: self.disposeBag)
        
        output.showRestaurantDetails
            .subscribe(onNext: { [weak self] model in
                self?.showRestaurantDetails(model)
                    ?? print("Warning: self already deallocated")
            })
            .disposed(by: self.disposeBag)
    }
    
    private func showRestaurantDetails(_ model: RestaurantItemViewModel) {
        #warning("TODO")
        print("Model: \(model)")
    }
}
