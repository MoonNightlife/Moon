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
import Whisper

class BarActivityFeedViewController: UIViewController, BindableType, DisplayErrorType {
    
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
        viewModel.refreshAction.elements.do(onNext: { [weak self] activities in
            guard let strongSelf = self else {
                return
            }
            if let isEmpty = activities.first?.items.isEmpty, isEmpty {
                strongSelf.tableView.separatorStyle  = .none
                strongSelf.addEmpyDataView()
            } else {
                strongSelf.tableView.separatorStyle = .singleLine
                strongSelf.tableView.backgroundView = nil
            }
            strongSelf.refreshControl.endRefreshing()
            }).bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged).subscribe(viewModel.refreshAction.inputs).addDisposableTo(disposeBag)
        
        viewModel.refreshAction.errors.subscribe(onNext: { [weak self] in
            self?.refreshControl.endRefreshing()
            if let strongSelf = self {
                strongSelf.dispayErrorMessage(error: $0)
            }
        }).addDisposableTo(disposeBag)
        
        viewModel.refreshAction.execute()
    }
    
    fileprivate func addEmpyDataView() {
        let emptyImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        emptyImageView.image = #imageLiteral(resourceName: "DefaultMoonsView")
        tableView.backgroundView = emptyImageView
    }
    
    fileprivate func configureDataSource() {
        dataSource.configureCell = {
            [weak self] dataSource, tableView, indexPath, item in
            //swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: self!.barActivityCellIdenifier, for: indexPath) as! BarActivityTableViewCell
            if let strongSelf = self {
                cell.initializeCell()
                strongSelf.populate(activityCell: cell, activity: item)
            }
            return cell
        }
    }
    
    func populate(activityCell view: BarActivityTableViewCell, activity: Activity) {
        // Bind actions
        if let userID = activity.userID, let barID = activity.barID {
            
            let likeAction = viewModel.onLike(userID: userID)
            view.likeButton.rx.action = likeAction
            likeAction.elements.do(onNext: {
                view.toggleColorAndNumber()
            }).subscribe().addDisposableTo(view.bag)
            
            let hasLiked = viewModel.hasLikedActivity(activityID: userID)
            hasLiked.elements.do(onNext: { hasLiked in
                if hasLiked {
                    view.likeButton.tintColor = .red
                    view.heartColor = .red
                }
            }).subscribe().addDisposableTo(view.bag)
            hasLiked.execute()
            
            
            view.user.rx.action = viewModel.onView(userID: userID)
            view.bar.rx.action = viewModel.onView(barID: barID)
            view.numLikeButton.rx.action = viewModel.onViewLikers(userID: userID)
            
            let downloader = viewModel.getProfileImage(id: userID)
            downloader.elements.bind(to: view.profilePicture.rx.image).addDisposableTo(view.bag)
            downloader.execute()
            
        }
        
        // Bind labels
        view.user.setTitle(activity.userName, for: .normal)
        view.bar.setTitle(activity.barName, for: .normal)
        view.numLikeButton.setTitle("\(activity.numLikes ?? 0)", for: .normal)
        
        if let time = activity.timestamp {
            let date = Date.init(timeIntervalSince1970: time)
            view.timeLabel.text = date.getElaspedTimefromDate()
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
