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
    
    let resultsDataSource = RxTableViewSectionedAnimatedDataSource<SnapshotSectionModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        prepareSegmentControl()
        
        searchResultsTableView.rx.setDelegate(self).disposed(by: bag)
    }

    func bindViewModel() {
        
        viewModel.searchResults.bind(to: searchResultsTableView.rx.items(dataSource: resultsDataSource)).addDisposableTo(bag)
    
        segmentControl.rx.controlEvent(UIControlEvents.valueChanged)
            .map({ [weak self] in
                return SearchType(rawValue: self?.segmentControl.selectedIndex ?? 0) ?? .users
            })
            .subscribe(viewModel.selectedSearchType)
            .addDisposableTo(bag)
        
        searchResultsTableView.rx.itemSelected.map({
            return $0.row
        }).subscribe(viewModel.onShowResult.inputs).addDisposableTo(bag)
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
        resultsDataSource.configureCell = { [weak self]
            dataSource, tableView, indexPath, item in
            
            switch item {
            case .searchResult(let snapshot):
                //swiftlint:disable:next force_cast
                let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
                cell.initCellWith()
                cell.nameLabel.text = snapshot.name
                cell.usernameLabel.text = snapshot.username ?? ""
                
                let isBarSnap = snapshot.username  == nil ? true : false
                
                if isBarSnap {
                    cell.mainImageView.backgroundColor = .clear
                    cell.mainImageView.image = #imageLiteral(resourceName: "LocationIcon")
                } else {
                    cell.mainImageView.backgroundColor = .moonGrey
                    cell.mainImageView.image = nil
                }
                
                if !isBarSnap, let id = snapshot.id, let strongSelf = self {
                    let downloader = strongSelf.viewModel.getProfileImage(id: id)
                    downloader.elements.bind(to: cell.mainImageView.rx.image).disposed(by: cell.bag)
                    downloader.execute()
                }
                
                return cell
            case .loadMore(let action):
                //swiftlint:disable:next force_cast
                let cell = tableView.dequeueReusableCell(withIdentifier: "LoadMore", for: indexPath) as! LoadMoreTableViewCell
                cell.initCell(loadAction: action)
                return cell
            }
            
        }
    }
    
}

extension Reactive where Base : UITableView {}
