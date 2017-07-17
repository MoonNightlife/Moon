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
import SwiftOverlays

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        viewModel.checkContactAccess.execute()
    }
    
    func bindViewModel() {
        
        viewModel.showLoadingIndicator.asObservable()
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.showWaitOverlayWithText("Fetching Users In Contacts")
                } else {
                    self?.removeAllOverlays()
                }
            })
            .addDisposableTo(bag)
        
        navBackButton.rx.action = viewModel.onBack()
        
        viewModel.usersInContacts.bind(to: contactsTableView.rx.items(dataSource: dataSource)).addDisposableTo(bag)
        
        viewModel.checkContactAccess.elements.subscribe(onNext: { [weak self] accessGranted in
            if !accessGranted {
                self?.showMessage(message: "Please allow moon to use your contacts to find your friends.")
            }
        }).addDisposableTo(bag)
    
    }
    
    fileprivate func configureDataSource() {
        dataSource.configureCell = {
            [weak self] dataSource, tableView, indexPath, item in
            //swiftlint:disable force_cast
            switch item {
            case .loadMore(_):
                //TODO: turn the load more cell into a XIB and use it here
                return UITableViewCell()
            case let .searchResult(snapshot):
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactTableViewCell
                cell.name.text = snapshot.name
                cell.selectionStyle = .none
                if let id = snapshot.id {
                    cell.addFriendButton.rx.action = self?.viewModel.onAddFriend(userID: id)
                    let downloader = self?.viewModel.getProfileImage(id: id)
                    downloader?.elements.bind(to: cell.profilePicture.rx.image).addDisposableTo(cell.bag)
                    downloader?.execute()
                }
                return cell
            case .loading:
                return UITableViewCell()
            case let .contact(name, phoneNumber):
                let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "InviteContactCell")
                
                cell.selectionStyle = .none
                
                cell.textLabel?.text = name
                cell.textLabel?.font = UIFont.moonFont(size: 16)
                
                cell.detailTextLabel?.text = phoneNumber
                cell.detailTextLabel?.font = UIFont.moonFont(size: 14)
                
                let inviteButton = UIButton(type: UIButtonType.roundedRect)
                inviteButton.setTitle("Invite", for: .normal)
                inviteButton.tintColor = .lightGray
                cell.accessoryView = inviteButton
                inviteButton.sizeToFit()
                
                return cell
            }

        }
    }

    func showMessage(message: String) {
        let alertController = UIAlertController(title: "Moon", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let dismissAction = UIAlertAction(title: "Settings", style: UIAlertActionStyle.default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }

        alertController.addAction(dismissAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    fileprivate func prepareNavigationBackButton() {
        navBackButton = UIBarButtonItem()
        navBackButton.image = Icon.cm.arrowDownward
        navBackButton.tintColor = .lightGray
        self.navigationItem.leftBarButtonItem = navBackButton
    }

}
