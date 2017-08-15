//
//  RelationshipViewController.swift
//  Moon
//
//  Created by Evan Noble on 7/23/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Material

class RelationshipViewController: UIViewController, BindableType, ParentType {

    var viewModel: RelationshipViewModel!
    var bag = DisposeBag()
    var backButton: UIBarButtonItem!
    var contactsButton = UIBarButtonItem()
    
    // Protocal Implementation
    var view1: UIView! {
        get {
            return friendsView
        }
        set {
            friendsView = newValue
        }
    }
    
    var view2: UIView! {
        get {
            return groupsView
        }
        set {
            groupsView = newValue
        }
    }
    
    @IBOutlet weak var relationSegmentControl: ADVSegmentedControl!
    @IBOutlet weak var groupsView: UIView!
    @IBOutlet weak var friendsView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareSegmentControl()
        prepareNavigationBackButton()
        prepareContactsButton()
    }
    
    func bindViewModel() {
        relationSegmentControl.rx.controlEvent(UIControlEvents.valueChanged)
            .subscribe(onNext: { [weak self] in
                if let strongSelf = self {
                    let newView = View.Relationship.from(int: strongSelf.relationSegmentControl.selectedIndex)
                    strongSelf.viewModel.onChangeChildView.execute(newView)
                }
            })
            .addDisposableTo(bag)
        
        contactsButton.rx.action = viewModel.onShowContacts()
        backButton.rx.action = viewModel.onBack()
    }
    
    func prepareSegmentControl() {
        //segment set up
        relationSegmentControl.items = ["Friends"]
        relationSegmentControl.selectedLabelColor = .moonPurple
        relationSegmentControl.borderColor = .clear
        relationSegmentControl.backgroundColor = .clear
        relationSegmentControl.selectedIndex = 0
        relationSegmentControl.unselectedLabelColor = .lightGray
        relationSegmentControl.thumbColor = .moonPurple
    }
    
    func prepareNavigationBackButton() {
        backButton = UIBarButtonItem()
        backButton.image = Icon.cm.arrowDownward
        backButton.tintColor = .lightGray
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func prepareContactsButton() {
        contactsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "contactsIcon"), style: .plain, target: nil, action: nil)
        contactsButton.tintColor = .moonBlue
        self.navigationItem.rightBarButtonItem = contactsButton
    }
}

extension RelationshipViewController: UIPopoverPresentationControllerDelegate, PopoverPresenterType {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        
        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        viewModel.onBack().execute()
        return false
    }
    
    func didDismissPopover() {
        
    }
}
