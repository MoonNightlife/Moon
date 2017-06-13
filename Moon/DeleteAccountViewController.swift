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
    
    @IBOutlet weak var passwordField: TextField!
    @IBOutlet weak var emailField: TextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var viewModel: DeleteAccountViewModel!
    var navBackButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBackButton()
        prepareEmailTextField()
        preparePasswordTextField()
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
    
    fileprivate func preparePasswordTextField() {
        passwordField.placeholder = "Password"
        passwordField.isClearIconButtonEnabled = true
        passwordField.isSecureTextEntry = true
        passwordField.placeholderActiveColor = .moonGreen
        passwordField.dividerActiveColor = .moonGreen
        passwordField.dividerNormalColor = .moonGreen
        
        let leftView = UIImageView()
        leftView.image = #imageLiteral(resourceName: "passwordIcon")
        leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
        leftView.tintColor = .lightGray
        
        passwordField.leftView = leftView
        passwordField.leftViewActiveColor = .moonGreen
    }
}
