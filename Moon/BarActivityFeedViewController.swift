//
//  BarActivityFeedViewController.swift
//  Moon
//
//  Created by Evan Noble on 5/11/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import RxDataSources
import Action
import RxSwift
import RxCocoa

class BarActivityFeedViewController: UIViewController, BindableType {
    
    class func instantiateFromStoryboard() -> BarActivityFeedViewController {
        let storyboard = UIStoryboard(name: "MoonsView", bundle: nil)
        // swiftlint:disable:next force_cast
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! BarActivityFeedViewController
    }
    
    var viewModel: BarActivityFeedViewModel!
    let barActivityCellIdenifier = "barActivityCell"
    let dataSource = RxTableViewSectionedAnimatedDataSource<ActivitySection>()
    private let disposeBag = DisposeBag()
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        configureDataSource()
        viewSetUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     
    func bindViewModel() {
    
        viewModel.refreshAction.elements.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        viewModel.refreshAction.executionObservables.subscribe(onNext: { [unowned self] _ in self.refreshControl.endRefreshing() }).disposed(by: disposeBag)
        refreshControl.rx.controlEvent(.valueChanged).subscribe(viewModel.refreshAction.inputs).addDisposableTo(disposeBag)
    }
    
    fileprivate func configureDataSource() {
        dataSource.configureCell = {
            [weak self] dataSource, tableView, indexPath, item in
            //swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: self!.barActivityCellIdenifier, for: indexPath) as! BarActivityTableViewCell
            if let strongSelf = self {
                cell.initializeCellWith(activity: item,
                                        userAction: strongSelf.viewModel.onViewUser(),
                                        barAction: strongSelf.viewModel.onViewBar(),
                                        likeAction: strongSelf.viewModel.onLike(),
                                        userLikedAction: strongSelf.viewModel.onViewLikers())
            }
            return cell
        }
    }

}

extension BarActivityFeedViewController {
    fileprivate func viewSetUp() {
        // TableView set up
        tableView.rowHeight = 75
        self.tableView.separatorStyle = .singleLine
        tableView.backgroundColor = Color.grey.lighten5
        
        // Add the refresh control
        tableView.addSubview(refreshControl)
    }
}
