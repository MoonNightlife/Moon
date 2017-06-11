//
//  ContentSuggestionsViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/9/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift

typealias BarSearchSection = AnimatableSectionModel<String, BarCell>
typealias UserSearchSection = AnimatableSectionModel<String, UserCell>

class ContentSuggestionsViewController: UIViewController, BindableType {
    
    var viewModel: ContentSuggestionsViewModel!
    
    private let barTableCellResuseIdenifier = "BarSearchTableViewCell"
    private let userCollectionCellReuseIdenifier = "UserSearchCollectionViewCell"
    let barDataSource = RxTableViewSectionedAnimatedDataSource<BarSearchSection>()
    let userDataSource = RxCollectionViewSectionedAnimatedDataSource<UserSearchSection>()
    private let bag = DisposeBag()
    
    @IBOutlet var suggestedUserColletionView: UICollectionView!
    @IBOutlet var suggestedBarTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBarController?.searchBar.textField.becomeFirstResponder()
    }
    
    func bindViewModel() {
        viewModel.suggestedBars.drive(suggestedBarTableView.rx.items(dataSource: barDataSource)).disposed(by: bag)
        viewModel.suggestedFriends.drive(suggestedUserColletionView.rx.items(dataSource: userDataSource)).disposed(by: bag)
    }
    
    fileprivate func configureDataSource() {
        barDataSource.configureCell = {
            [weak self] dataSource, tableView, indexPath, item in
            //swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: self!.barTableCellResuseIdenifier, for: indexPath) as! BarSearchTableViewCell
            if let strongSelf = self {
                cell.initCellWith(bar: item)
            }
            return cell
        }
        
        userDataSource.configureCell = {
            [weak self] dataSource, collectionView, indexPath, item in
            //swiftlint:disable force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self!.userCollectionCellReuseIdenifier, for: indexPath) as! UserSearchCollectionViewCell
            if let strongSelf = self {
                cell.initCellWith(user: item)
            }
            return cell
        }
    }

}

extension Reactive where Base : UITableView {}
