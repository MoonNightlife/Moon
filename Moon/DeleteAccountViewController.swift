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
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var viewModel: DeleteAccountViewModel!
    var navBackButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBackButton()
        prepareDeleteButton()
    }

    func bindViewModel() {
        navBackButton.rx.action = viewModel.onBack()
        deleteButton.rx.action = viewModel.onDelete()
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
