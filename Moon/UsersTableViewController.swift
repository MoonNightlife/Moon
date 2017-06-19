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

class UsersTableViewController: UIViewController, BindableType, UIPopoverPresentationControllerDelegate {

    var viewModel: UsersTableViewModel!
    private let bag = DisposeBag()
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var showContactsButton: UIButton!
    var backButton: UIBarButtonItem!
    
    @IBOutlet weak var contactsViewHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareNavigationBackButton()
        prepareContactButton()
        
        self.view.backgroundColor = UIColor.lightGray
        contactsViewHeightConstraint.constant = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Animation Logic
        if true {
        animateView()
        }
    }

    func bindViewModel() {
        viewModel.users.drive(userTableView.rx.items(cellIdentifier: "UsersTableCell", cellType: UsersTableViewCell.self)) { (_, element, cell) in
                cell.profilePicture.image = element.picture
                cell.profilePicture.cornerRadius = cell.profilePicture.frame.size.width / 2
                cell.profilePicture.clipsToBounds = true
            
                cell.name.text = element.name
                cell.name.textColor = .lightGray
            }
            .disposed(by: bag)
        
        let selectedItem = userTableView.rx.itemSelected
        selectedItem.subscribe(onNext: { [weak self] _ in
            self?.viewModel.onShowUser().execute()
        })
        .disposed(by: bag)
        
        backButton.rx.action = viewModel.onBack()
        showContactsButton.rx.action = viewModel.onShowContacts()
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
