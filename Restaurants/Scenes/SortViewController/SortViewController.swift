//
//  SortViewController.swift
//  Restaurants
//
//  Created by Modo Ltunzher on 19.01.2020.
//  Copyright © 2020 Modo Ltunzher. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SortViewController: UITableViewController {
    
    private let viewModel: SortViewModel
    let cellId = "cell"
    let disposeBag = DisposeBag()
    
    init(viewModel: SortViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
        self.title = "Sort"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = nil
        self.tableView.dataSource = nil

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellId)
        self.bindModel(self.viewModel)
    }
    
    private func bindModel(_ model: SortViewModel) {
        let indexSelected = self.tableView.rx
            .itemSelected
            .do(onNext: { [weak self] (indexPath) in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            })
            .map { $0.row }
        
        let input = SortViewModel.Input(indexSelected: indexSelected)
        
        let output = self.viewModel.transform(input: input)
        
        let options = Observable.just(output.options)
        let index = output.index.asObservable()
        Observable.combineLatest(options, index)
            .map { list, index -> [(String, Int)] in
                list.map { ($0, index) }
            }
            .do(onNext: {
                print("Table view new items \($0)")
            })
            .bind(to: self.tableView.rx.items(cellIdentifier: self.cellId)) { row, tuple, cell in
                cell.textLabel?.text = tuple.0
                cell.accessoryType = row == tuple.1 ? .checkmark : .none
            }
            .disposed(by: self.disposeBag)
    }
}
