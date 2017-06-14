//
//  SearchResultsViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/11/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import RxDataSources
import RxCocoa
import Action
import RxSwift

class SearchResultsViewController: UIViewController, BindableType, UITableViewDelegate {
    
    @IBOutlet weak var segmentControl: ADVSegmentedControl!

    private let bag = DisposeBag()
    var viewModel: SearchResultsViewModel!

    @IBOutlet weak var searchResultsTableView: UITableView!
    
    let resultsDataSource = RxTableViewSectionedReloadDataSource<SearchSectionModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        prepareSegmentControl()
        
        searchResultsTableView.rx.setDelegate(self).disposed(by: bag)
    }
    func bindViewModel() {
        
        searchResultsTableView.rx.itemSelected.map({ $0.row }).subscribe(onNext: { [weak self] _ in
            self?.viewModel.onShowProfile().execute("123")
        }).addDisposableTo(bag)
        
        viewModel.selectedSearchType.elements.bind(to: searchResultsTableView.rx.items(dataSource: resultsDataSource)).addDisposableTo(bag)
    
        segmentControl.rx.controlEvent(UIControlEvents.valueChanged)
            .map({ [weak self] in
                return SearchType(rawValue: self?.segmentControl.selectedIndex ?? 0) ?? .users
            })
            .subscribe(viewModel.selectedSearchType.inputs)
            .addDisposableTo(bag)
        
        viewModel.selectedSearchType.execute(.users)
        
        guard let searchBar = searchBarController?.searchBar else {
            return
        }
        
        searchBar.textField.rx.textInput.text.bind(to: viewModel.searchText).addDisposableTo(bag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    fileprivate func prepareSegmentControl() {
        //segment set up
        segmentControl.items = ["People", "Bars"]
        segmentControl.selectedLabelColor = .lightGray
        segmentControl.borderColor = .clear
        segmentControl.backgroundColor = .clear
        segmentControl.selectedIndex = 0
        segmentControl.unselectedLabelColor = .moonGrey
        segmentControl.thumbColor = .moonGrey
    }
    
    fileprivate func configureDataSource() {        
        resultsDataSource.configureCell = {
            dataSource, tableView, indexPath, item in
            
            var cell: UITableViewCell
            switch item {
            case .searchResultItem(let snapshot):
                cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath)
                //swiftlint:disable:next force_cast
                (cell as! SearchTableViewCell).initCellWith(snapshot: snapshot)
            case .loadMoreItem(let action):
                cell = tableView.dequeueReusableCell(withIdentifier: "LoadMore", for: indexPath)
                //swiftlint:disable:next force_cast
                (cell as! LoadMoreTableViewCell).initCell(loadAction: action)
            }
            
            return cell
        }
    }
    
}

extension Reactive where Base : UITableView {}
