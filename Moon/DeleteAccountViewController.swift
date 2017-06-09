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

class DeleteAccountViewController: UIViewController, BindableType {
    
    var viewModel: DeleteAccountViewModel!
    var navBackButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBackButton()
    }

    func bindViewModel() {
        navBackButton.rx.action = viewModel.onBack()
    }

    fileprivate func prepareNavigationBackButton() {
        navBackButton = UIBarButtonItem()
        navBackButton.image = Icon.cm.arrowBack
        navBackButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = navBackButton
    }
}
