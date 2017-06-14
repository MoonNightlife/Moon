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

typealias SearchSection = AnimatableSectionModel<String, SearchSnapshot>

class ContentSuggestionsViewController: UIViewController, BindableType {
    @IBOutlet weak var suggestedUsersLabel: UILabel!
    @IBOutlet weak var suggestedBarsLabel: UILabel!
    
    var viewModel: ContentSuggestionsViewModel!
    
    private let barCollectionCellResuseIdenifier = "BarSnapshotCell"
    private let userCollectionCellReuseIdenifier = "UserSearchCollectionViewCell"
    let barDataSource = RxCollectionViewSectionedAnimatedDataSource<SearchSection>()
    let userDataSource = RxCollectionViewSectionedAnimatedDataSource<SearchSection>()
    private let bag = DisposeBag()
    
    @IBOutlet var suggestedUserColletionView: UICollectionView!
    @IBOutlet var suggestedBarCollectionView: UICollectionView!
    
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
        prepareLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBarController?.searchBar.textField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBarController?.searchBar.textField.resignFirstResponder()
    }
    
    func prepareLabels() {
        suggestedUsersLabel.textColor = .lightGray
        suggestedUsersLabel.dividerThickness = 1.8
        suggestedUsersLabel.dividerColor = .moonGrey
        
        suggestedBarsLabel.textColor = .lightGray
        suggestedBarsLabel.dividerThickness = 1.8
        suggestedBarsLabel.dividerColor = .moonGrey
    }
    
    func bindViewModel() {
        viewModel.suggestedBars.drive(suggestedBarCollectionView.rx.items(dataSource: barDataSource)).disposed(by: bag)
        viewModel.suggestedFriends.drive(suggestedUserColletionView.rx.items(dataSource: userDataSource)).disposed(by: bag)
    }
    
    fileprivate func configureDataSource() {
        barDataSource.configureCell = {
            [weak self] dataSource, collectionView, indexPath, item in
            //swiftlint:disable force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self!.barCollectionCellResuseIdenifier, for: indexPath)
            
//            print("Cell Size: " , cell.frame.size.height)
//            print("CollectionView Heigh: t", collectionView.frame.size.height)
//            print("iPhone Height: ", self?.view.frame.size.height)
//            print("iPhone Width: " , self?.view.frame.size.width)
            
            let cellSize = collectionView.frame.size.height * 0.526
            cell.frame.size.height = cellSize
            cell.frame.size.width = cellSize
            
            let size = cellSize * 0.833
            
            let view = BarCollectionView()
            view.frame = CGRect(x: (cell.frame.size.width / 2) - (size / 2), y: (cell.frame.size.height / 2) - (size / 2), width: size, height: size)
            view.backgroundColor = .clear
            
            if let strongSelf = self {
               view.initViewWith(bar: item)
            }
            
            cell.addSubview(view)
            return cell
        }
        
        userDataSource.configureCell = {
            [weak self] dataSource, collectionView, indexPath, item in
            //swiftlint:disable force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self!.userCollectionCellReuseIdenifier, for: indexPath)
            
            print(collectionView.frame.size.height)
            
            let size = collectionView.frame.size.height * 0.86
            
            let view = UserCollectionView()
            view.frame = CGRect(x: 2, y: 0, width: size, height: size)
            view.backgroundColor = .clear
            
            if let strongSelf = self {
                view.initViewWith(user: item)
            }
            
            cell.addSubview(view)
            return cell
        }
    }

}

extension Reactive where Base : UITableView {}
