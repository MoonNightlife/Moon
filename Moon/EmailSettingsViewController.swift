//
//  EmailSettingsViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/8/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Material

class EmailSettingsViewController: UIViewController, BindableType {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var emailField: ErrorTextField!
    var viewModel: EmailSettingsViewModel!
    var navBackButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBackButton()
        prepareEmailTextField()
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
    
    fileprivate func prepareEmailTextField() {
        emailField.placeholder = "Email"
        emailField.detail = "Invalid Email"
        emailField.isClearIconButtonEnabled = true
        emailField.placeholderActiveColor = .moonRed
        emailField.dividerActiveColor = .moonRed
        emailField.dividerNormalColor = .moonRed
        
        let leftView = UIImageView()
        leftView.image = #imageLiteral(resourceName: "emailIcon")
        leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
        leftView.tintColor = .lightGray
        
        emailField.leftView = leftView
        emailField.leftViewActiveColor = .moonRed
        
    }
}
