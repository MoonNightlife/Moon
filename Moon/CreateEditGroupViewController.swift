//
//  CreateEditGroupViewController.swift
//  Moon
//
//  Created by Evan Noble on 7/23/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import Action

class CreateEditGroupViewController: UIViewController, BindableType {
    
    // MARK: - Global
    var viewModel: CreateEditGroupViewModel!
    var backButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareNavigationBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func bindViewModel() {
        backButton.rx.action = viewModel.onBack()
        backButton.image = viewModel.showBackArrow ? Icon.cm.arrowBack : Icon.cm.arrowDownward
    }
    
    func prepareNavigationBackButton() {
        self.navigationItem.hidesBackButton = true
        backButton = UIBarButtonItem()
        backButton.tintColor = .lightGray
        self.navigationItem.leftBarButtonItem = backButton
    }

}
