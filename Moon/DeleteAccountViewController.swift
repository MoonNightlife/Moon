//
//  DeleteAccountViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/8/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Material
import SwiftOverlays

class DeleteAccountViewController: UIViewController, BindableType {
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var viewModel: DeleteAccountViewModel!
    var navBackButton: UIBarButtonItem!
    var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBackButton()
        prepareDeleteButton()
    }

    func bindViewModel() {
        navBackButton.rx.action = viewModel.onBack()
        
        let deleteAction = viewModel.onDelete()
        deleteButton.rx.action = deleteAction
        deleteAction.executing.subscribe(onNext: {
            if $0 {
                SwiftOverlays.showBlockingWaitOverlayWithText("Deleting Account")
            } else {
                SwiftOverlays.removeAllBlockingOverlays()
            }
        })
        .addDisposableTo(bag)
    }

    fileprivate func prepareNavigationBackButton() {
        navBackButton = UIBarButtonItem()
        navBackButton.image = Icon.cm.arrowBack
        navBackButton.tintColor = .lightGray
        self.navigationItem.leftBarButtonItem = navBackButton
    }
    
    fileprivate func prepareDeleteButton() {
        deleteButton.backgroundColor = .moonRed
        deleteButton.tintColor = .white
        deleteButton.layer.cornerRadius = 5
    }
}
