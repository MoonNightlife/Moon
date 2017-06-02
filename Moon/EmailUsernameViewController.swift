//
//  EmailUsernameViewController.swift
//  Moon
//
//  Created by Evan Noble on 5/31/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import RxSwift
import RxCocoa

class EmailUsernameViewController: UIViewController, BindableType {
    
    var viewModel: EmailUsernameViewModel!
    let disposeBag = DisposeBag()

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var usernameTextField: ErrorTextField!
    @IBOutlet weak var emailTextField: ErrorTextField!
    var navBackButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareEmailTextField()
        prepareUsernameTextField()
        prepareNavigationBackButton()
    }

    func bindViewModel() {
        usernameTextField.rx.textInput.text.bind(to: viewModel.username).addDisposableTo(disposeBag)
        emailTextField.rx.textInput.text.bind(to: viewModel.email).addDisposableTo(disposeBag)
        
        viewModel.showUsernameError.bind(to: usernameTextField.rx.isErrorRevealed).addDisposableTo(disposeBag)
        viewModel.showEmailError.drive(emailTextField.rx.isErrorRevealed).addDisposableTo(disposeBag)

        navBackButton.rx.action = viewModel.onBack()
        nextButton.rx.action = viewModel.nextSignUpScreen()
    }
    
}

extension EmailUsernameViewController {
    fileprivate func prepareUsernameTextField() {
        usernameTextField.placeholder = "Username"
        usernameTextField.detail = "Invailid Username"
        usernameTextField.isClearIconButtonEnabled = true
    }
    fileprivate func prepareEmailTextField() {
        emailTextField.placeholder = "Email"
        emailTextField.detail = "Invalid Email"
        emailTextField.isClearIconButtonEnabled = true
    }
    
    fileprivate func prepareNavigationBackButton() {
        navBackButton = UIBarButtonItem()
        navBackButton.title = "Back"
        self.navigationItem.leftBarButtonItem = navBackButton
    }
}
