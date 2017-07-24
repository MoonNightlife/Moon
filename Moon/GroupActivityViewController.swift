//
//  GroupActivityViewController.swift
//  Moon
//
//  Created by Evan Noble on 7/23/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import Action

class GroupActivityViewController: UIViewController, BindableType {

    // MARK: - Global
    var viewModel: GroupActivityViewModel!
    var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBackButton()
    }
    
    func bindViewModel() {
        backButton.rx.action = viewModel.onBack()
    }
    
    func prepareNavigationBackButton() {
        backButton = UIBarButtonItem()
        backButton.image = Icon.cm.arrowDownward
        backButton.tintColor = .lightGray
        self.navigationItem.leftBarButtonItem = backButton
    }

}
