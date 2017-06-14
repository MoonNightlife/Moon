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

enum SearchSectionModel {
    case searchResultsSection(title: String, items: [SearchSectionItem])
    case loadMore(title: String, items: [SearchSectionItem])
}

enum SearchSectionItem {
    case searchResultItem(snapshot: SearchSnapshot)
    case loadMoreItem(loadAction: CocoaAction)
}

extension SearchSectionModel: SectionModelType {
    typealias Item = SearchSectionItem
    
    var items: [SearchSectionItem] {
        switch self {
        case let .searchResultsSection(_, items):
            return items.map {$0}
        case let .loadMore(_, items):
            return items.map {$0}
        }
    }
    
    var titles: String {
        switch self {
        case let .searchResultsSection(title, _):
            return title
        case let .loadMore(title, _):
            return title
        }
    }
    
    init(original: SearchSectionModel, items: [Item]) {
        switch original {
        case let .searchResultsSection(t, _):
            self = .searchResultsSection(title: t, items: items)
        case let .loadMore(t, _):
            self = .loadMore(title: t, items: items)
        }
    }
}

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
        viewModel.searchResults.drive(searchResultsTableView.rx.items(dataSource: resultsDataSource)).addDisposableTo(bag)
        
        guard let searchBar = searchBarController?.searchBar else {
            return
        }
        
        searchBar.textField.rx.textInput.text.bind(to: viewModel.searchText).addDisposableTo(bag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0;//Choose your custom row height
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
        resultsDataSource.titleForHeaderInSection = { ds, index in
            let models = ds.sectionModels
            if (index == 0 || index == 2) && !models[index].items.isEmpty {
                return models[index].titles
            } else {
                return ""
            }
        }
        
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
