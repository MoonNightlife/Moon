//
//  ViewGroupsViewController.swift
//  Moon
//
//  Created by Evan Noble on 7/23/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import MaterialComponents
import Material
import RxDataSources

class ViewGroupsViewController: UIViewController, BindableType {
    
    // MARK: - Global
    var viewModel: ViewGroupsViewModel!
    var bag = DisposeBag()
    var groupsDataSource = RxTableViewSectionedReloadDataSource<SnapshotSectionModel>()

    @IBOutlet weak var viewActivity: UIButton!
    @IBOutlet weak var create: MDCFloatingButton!
    @IBOutlet weak var groupsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "BasicImageCell", bundle: nil)
        groupsTableView.register(nib, forCellReuseIdentifier: "BasicImageCell")

        // Do any additional setup after loading the view.
        prepareCreateButton()
        configureDataSource()
    }

    func bindViewModel() {
        create.rx.action = viewModel.onCreate()
        viewActivity.rx.action = viewModel.onViewActivity()
        
        groupsTableView.rx.modelSelected(SnapshotSectionModel.Item.self)
            .do(onNext: { [weak self] _ in
                guard let selectedIndexPath = self?.groupsTableView.indexPathForSelectedRow else {
                    return
                }
                self?.groupsTableView.deselectRow(at: selectedIndexPath, animated: true)
            })
            .map {$0.id}
            .filterNil()
            .bind(to: viewModel.onManageGroup.inputs).addDisposableTo(bag)
        
        viewModel.groupsToDisplay.bind(to: groupsTableView.rx.items(dataSource: groupsDataSource)).addDisposableTo(bag)
        viewModel.getGroups.execute()
    }
    
    func prepareCreateButton() {
        create.backgroundColor = .moonGrey
        create.setBackgroundColor(.moonGrey, for: .normal)
        create.setImage(Icon.add, for: .normal)
        create.tintColor = .moonGreen
        
    }
    
    func configureDataSource() {
        groupsDataSource.configureCell = { [weak self] dataSource, tableView, indexPath, item in
            
            guard let strongSelf = self else {
                return UITableViewCell()
            }
            
            //swiftlint:disable:next force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicImageCell", for: indexPath) as! BasicImageTableViewCell
            cell.viewModel = strongSelf.viewModel.viewModelForCell(snapshot: item)
        
            return cell
        }
    }
}
