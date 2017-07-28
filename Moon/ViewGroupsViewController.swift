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

    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var viewActivity: UIButton!
    @IBOutlet weak var create: MDCFloatingButton!
    var groupsDataSource = RxTableViewSectionedReloadDataSource<GroupMemberSectionModel>()
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareCreateButton()
    }

    func bindViewModel() {
        viewButton.rx.action = viewModel.onManageGroup()
        viewActivity.rx.action = viewModel.onViewActivity()
        create.rx.action = viewModel.onCreate()
    }
    
    func prepareCreateButton() {
        create.backgroundColor = .moonGrey
        create.setBackgroundColor(.moonGrey, for: .normal)
        create.setImage(Icon.add, for: .normal)
        create.tintColor = .moonGreen
        
    }
    
    func configureDataSource() {
        groupsDataSource.configureCell = { dataSource, collectionView, indexPath, item in
            
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "groupCell")
            
            cell.textLabel?.text = item.name
            
            return cell
        }
    }
}
