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
    private let viewAppearRelay = BehaviorRelay<Bool>(value: false)
    private let filterTextRelay = BehaviorRelay<String>(value: String())
    
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

        // filter input
        let (headerView, filterTextDriver) = self.createFilterInputView()
        self.tableView.tableHeaderView = headerView
        
        // route filter text into relay to be used as input for model
        filterTextDriver.asObservable()
            .map { $0 ?? String()}
            .bind(to: self.filterTextRelay)
            .disposed(by: self.disposeBag)
        
        RestaurantItemCell.register(in: self.tableView, reuseId: self.cellId)
        self.bindModel(self.viewModel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Some interactive dismisal may be cancelled without calling didDisappear
        // May also use RxViewController here
        self.viewAppearRelay.accept(true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewAppearRelay.accept(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewAppearRelay.accept(false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewAppearRelay.accept(false)
    }

    private func bindModel(_ model: RestaurantListViewModel) {
        // exposing events
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        let itemAtIndexSelected = self.tableView.rx
            .itemSelected
            .do(onNext: { [weak self] in
                self?.tableView.deselectRow(at: $0, animated: true)
            })
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { $0.row }
        let sortTapped = self.buttonItemSort.rx
            .tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
        let viewVisible = self.viewAppearRelay.asObservable()
        
        let input = RestaurantListViewModel.Input(
            itemAtIndexSelected: itemAtIndexSelected,
            sortTapped: sortTapped,
            viewVisible: viewVisible,
            filterText: self.filterTextRelay.asDriver()
        )
        
        // consuming
        let output = self.viewModel.transform(input: input)

        let listAndViewVisible = Observable.combineLatest(
            output.list.asObservable(),
            self.viewAppearRelay.asObservable()
        )
        
        listAndViewVisible
            .filter {
                print("View is visible \($1)")
                return $1 == true
            }
            .map { (list, _) -> [RestaurantItemViewModel] in list }
            .bind(to: self.tableView.rx.items(cellIdentifier: self.cellId)) { row, itemModel, cell in
                let itemCell = cell as? RestaurantItemCell
                itemCell?.setModel(model: itemModel, sortField: model.currentSortField)
            }
            .disposed(by: self.disposeBag)
        
        output.showRestaurantDetails
            .subscribe(onNext: { [weak self] model in
                self?.showRestaurantDetails(model)
                    ?? print("Warning: self already deallocated")
            })
            .disposed(by: self.disposeBag)
        
        output.showSortOptions
            .subscribe(onNext: { [weak self] viewModel in
                self?.showSortingOptions(model: viewModel)
                    ?? print("Warning: self already deallocated")
            })
            .disposed(by: self.disposeBag)
    }
    
    private func createFilterInputView() -> (UIView, Driver<String?>) {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Filter by name"
        searchBar.searchBarStyle = .minimal
        searchBar.returnKeyType = .done
        searchBar.sizeToFit()
        
        let toolbar = UIToolbar()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        toolbar.setItems([doneButton], animated: false)
        toolbar.sizeToFit()
        searchBar.inputAccessoryView = toolbar

        // Done or Return to dismiss keyboard
        Observable.of(
                searchBar.rx.searchButtonClicked.asObservable(),
                doneButton.rx.tap.asObservable()
            )
            .flatMap { $0 }
            .subscribe(onNext: { [weak self] in self?.viewIfLoaded?.endEditing(true) })
            .disposed(by: self.disposeBag)
        
        return (searchBar, searchBar.rx.text.asDriver())
    }
    
    private func showRestaurantDetails(_ model: RestaurantItemViewModel) {
        #warning("TODO")
        print("Model: \(model)")
    }
    
    private func showSortingOptions(model: SortViewModel) {
        let viewController = SortViewController(viewModel: model)
        self.navigationController?.show(viewController, sender: nil)
    }
}
