//
//  ContactsViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/16/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Action
import RxCocoa
import RxSwift
import Material
import RxDataSources

class ContactsViewController: UIViewController, BindableType {

    var viewModel: ContactsViewModel!
    var navBackButton: UIBarButtonItem!
    @IBOutlet var contactsTableView: UITableView!
    
    let dataSource = RxTableViewSectionedAnimatedDataSource<SnapshotSectionModel>()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBackButton()
        configureDataSource()
    }
    
    func bindViewModel() {
        navBackButton.rx.action = viewModel.onBack()
        let rx_tableView = contactsTableView.rx
        viewModel.usersInContacts.drive(rx_tableView.items(dataSource: dataSource)).disposed(by: bag)

    }
    
    fileprivate func configureDataSource() {
        dataSource.configureCell = {
            [weak self] dataSource, tableView, indexPath, item in
            //swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactTableViewCell
            if let strongSelf = self {
                cell.initCell(user: item, addAction: strongSelf.viewModel.onAddFriend(userID: item.id))
            }
            return cell
        }
    }

    fileprivate func prepareNavigationBackButton() {
        navBackButton = UIBarButtonItem()
        navBackButton.image = Icon.cm.arrowDownward
        navBackButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = navBackButton
    }

}

extension Reactive where Base: UITableView {
    
}
