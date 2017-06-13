//
//  UsersTableViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/13/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Material

class UsersTableViewController: UIViewController, BindableType {

    var viewModel: UsersTableViewModel!
    private let bag = DisposeBag()
    @IBOutlet weak var userTableView: UITableView!
    var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareNavigationBackButton()
    }

    func bindViewModel() {
        viewModel.users.drive(userTableView.rx.items(cellIdentifier: "UsersTableCell", cellType: UsersTableViewCell.self)) { (row, element, cell) in
                cell.profilePicture.image = element.picture
                cell.name.text = element.name
            }
            .disposed(by: bag)
        
        backButton.rx.action = viewModel.onBack()
    }
    
    func prepareNavigationBackButton() {
        backButton = UIBarButtonItem()
        backButton.image = Icon.cm.arrowBack
        backButton.tintColor = .lightGray
        self.navigationItem.leftBarButtonItem = backButton
    }
}
