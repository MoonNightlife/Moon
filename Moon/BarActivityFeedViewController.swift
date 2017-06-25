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
import SwaggerClient

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
        viewModel.refreshAction.elements.do(onNext: { [weak self] _ in
            self?.refreshControl.endRefreshing()
            }, onError: { [weak self] _ in
            self?.refreshControl.endRefreshing()
        }).bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        refreshControl.rx.controlEvent(.valueChanged).subscribe(viewModel.refreshAction.inputs).addDisposableTo(disposeBag)
        viewModel.refreshAction.execute()
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
        if let activityID = activity.id, let userID = activity.userID, let barID = activity.barID {
            view.likeButton.rx.action = viewModel.onLike(activtyID: activityID)
            view.user.rx.action = viewModel.onView(userID: userID)
            view.bar.rx.action = viewModel.onView(barID: barID)
            view.numLikeButton.rx.action = viewModel.onViewLikers(activityID: activityID)
        }
        
        // Bind labels
        view.user.setTitle(activity.userName, for: .normal)
        view.bar.setTitle(activity.barName, for: .normal)
        view.numLikeButton.setTitle("\(activity.numLikes ?? 0)", for: .normal)
        
        if let time = activity.timestamp {
            let date = Date.init(timeIntervalSince1970: time)
            view.timeLabel.text = date.getElaspedTimefromDate()
        } else {
            //TODO: Add empty data text for timestamp
        }
        
        if let urlString = activity.pic, let url = URL(string: urlString) {
            let downloader = viewModel.downloadImage(url: url)
                downloader.elements.bind(to: view.profilePicture.rx.image).addDisposableTo(view.bag)
                downloader.execute()
        } else {
            view.profilePicture.image = #imageLiteral(resourceName: "DefaultProfilePic")
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
