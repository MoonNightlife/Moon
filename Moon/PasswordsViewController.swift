//
//  PasswordsViewController.swift
//  Moon
//
//  Created by Evan Noble on 5/31/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import RxSwift
import RxCocoa

class PasswordsViewController: UIViewController, BindableType {

    let disposeBag = DisposeBag()
    var viewModel: PasswordsViewModel!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var retypePasswordTextField: ErrorTextField!
    @IBOutlet weak var passwordTextField: ErrorTextField!
    var navBackButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        preparePasswordTextField()
        prepareRetypePasswordTextField()
        prepareNavigationBackButton()
    }

    func bindViewModel() {
        passwordTextField.rx.textInput.text.orEmpty.bind(to: viewModel.passwordText).addDisposableTo(disposeBag)
        retypePasswordTextField.rx.textInput.text.orEmpty.bind(to: viewModel.retypePasswordText).addDisposableTo(disposeBag)
        
        viewModel.showAcceptablePasswordError.bind(to: passwordTextField.rx.isErrorRevealed).addDisposableTo(disposeBag)
        viewModel.showPasswordsMatchError.bind(to: retypePasswordTextField.rx.isErrorRevealed).addDisposableTo(disposeBag)
        
        doneButton.rx.action = viewModel.onCreateUser()
        navBackButton.rx.action = viewModel.onBack()
    }
    
    fileprivate func prepareNavigationBackButton() {
        navBackButton = UIBarButtonItem()
        navBackButton.title = "Back"
        self.navigationItem.leftBarButtonItem = navBackButton
    }
}

extension PasswordsViewController {
    fileprivate func preparePasswordTextField() {
        passwordTextField.placeholder = "Password"
        passwordTextField.detail = "Invalid Password"
        passwordTextField.isClearIconButtonEnabled = true
        passwordTextField.isSecureTextEntry = true
    }
    fileprivate func prepareRetypePasswordTextField() {
        retypePasswordTextField.placeholder = "Retype Password"
        retypePasswordTextField.detail = "Passwords Do Not Match"
        retypePasswordTextField.isClearIconButtonEnabled = true
        retypePasswordTextField.isSecureTextEntry = true
    }
}
