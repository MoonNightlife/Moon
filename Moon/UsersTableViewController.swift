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
import Action
import Material
import RxDataSources
import SwaggerClient

class UsersTableViewController: UIViewController, BindableType, UIPopoverPresentationControllerDelegate {

    var viewModel: UsersTableViewModel!
    private let bag = DisposeBag()
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var showContactsButton: UIButton!
    var backButton: UIBarButtonItem!
    let dataSource = RxTableViewSectionedAnimatedDataSource<UserSectionModel>()
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    @IBOutlet weak var contactsViewHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareNavigationBackButton()
        prepareContactButton()
        
        self.view.backgroundColor = UIColor.lightGray
        contactsViewHeightConstraint.constant = 0
        
        configureDataSource()
        
        // Add the refresh control
        userTableView.addSubview(refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Animation Logic
        if true {
        animateView()
        }
    }

    func bindViewModel() {
        
        viewModel.users.do(onNext: { [weak self] _ in
            self?.refreshControl.endRefreshing()
        }).bind(to: userTableView.rx.items(dataSource: dataSource)).addDisposableTo(bag)
        
        let selectedItem = userTableView.rx.itemSelected
        selectedItem.subscribe(onNext: { [weak self] indexPath in
            self?.viewModel.onShowUser(indexPath: indexPath).execute()
        })
        .disposed(by: bag)
        
        backButton.rx.action = viewModel.onBack()
        showContactsButton.rx.action = viewModel.onShowContacts()
        
        refreshControl.rx.controlEvent(.valueChanged).bind(to: viewModel.reload).addDisposableTo(bag)
    }
    
    fileprivate func configureDataSource() {
        
        dataSource.titleForHeaderInSection = { ds, index in
            return ds.sectionModels[index].titles
        }
        
        dataSource.configureCell = {
            [weak self] dataSource, tableView, indexPath, item in
            
            if let strongSelf = self {
                switch item {
                case .friend(let snap):
                    
                    //swiftlint:disable force_cast
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableCell", for: indexPath) as! UsersTableViewCell
                    
                    let downloadAction = strongSelf.viewModel.downloadImage(url: URL(string: snap.pic ?? "")!)
                    downloadAction
                        .elements
                        .bind(to: cell.profilePicture.rx.image)
                        .addDisposableTo(cell.bag)
                    downloadAction.execute()
                    
                    cell.profilePicture.cornerRadius = cell.profilePicture.frame.size.width / 2
                    cell.profilePicture.clipsToBounds = true
                    
                    cell.name.text = snap.userName
                    cell.name.textColor = .lightGray
                    
                    return cell
                    
                case .friendRequest(let snap):
                    //swiftlint:disable force_cast
                    let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequest", for: indexPath) as! FriendRequestTableViewCell
                    
                    let downloadAction = strongSelf.viewModel.downloadImage(url: URL(string: snap.pic ?? "")!)
                    downloadAction
                        .elements
                        .bind(to: cell.profilePicture.rx.image)
                        .addDisposableTo(cell.bag)
                    downloadAction.execute()
                    
                    cell.profilePicture.cornerRadius = cell.profilePicture.frame.size.width / 2
                    cell.profilePicture.clipsToBounds = true
                    
                    cell.name.text = snap.userName
                    cell.name.textColor = .lightGray
                    
                    cell.acceptButton.titleLabel?.text = nil
                    cell.acceptButton.setImage(Icon.cm.check, for: .normal)
                    cell.acceptButton.tintColor = UIColor.moonGreen
                    
                    cell.declineButton.titleLabel?.text = nil
                    cell.declineButton.setImage(Icon.cm.close, for: .normal)
                    cell.declineButton.tintColor = UIColor.moonRed
                    
                    if let userID = snap.userID {
                        cell.acceptButton.rx.action = self?.viewModel.onAcceptFriendRequest(userID:userID)
                        cell.declineButton.rx.action = self?.viewModel.onDeclineFriendRequest(userID:userID)
                    }
                    
                    return cell
            
                }
            }
            
            return UITableViewCell()

        }
    }
    
    func prepareContactButton() {
        showContactsButton.tintColor = .moonBlue
        showContactsButton.titleLabel?.font = UIFont(name: "Roboto", size: 14)
    }
    
    func animateView() {
        UIView.animate(withDuration: Double(0.5), animations: {
            self.contactsViewHeightConstraint.constant = 75
            self.view.layoutIfNeeded()
        })
    }
    
    func prepareNavigationBackButton() {
        backButton = UIBarButtonItem()
        backButton.image = Icon.cm.arrowDownward
        backButton.tintColor = .lightGray
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        
        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        viewModel.onBack().execute()
        return false
    }
}
