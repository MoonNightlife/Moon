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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        viewModel.checkContactAccess.execute()
    }
    
    func bindViewModel() {
        
        navBackButton.rx.action = viewModel.onBack()
        
        viewModel.UserInContacts.bind(to: contactsTableView.rx.items(dataSource: dataSource)).addDisposableTo(bag)
        
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
                cell.addFriendButton.rx.action = self?.viewModel.onAddFriend(userID: snapshot._id!)
                self?.viewModel.downloadImage(url: URL(string: snapshot.pic!)!).elements.bind(to: cell.profilePicture.rx.image).addDisposableTo(cell.bag)
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
        navBackButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = navBackButton
    }

}
