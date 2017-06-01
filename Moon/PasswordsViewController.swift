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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        preparePasswordTextField()
        prepareRetypePasswordTextField()
    }

    func bindViewModel() {
        doneButton.rx.action = viewModel.onCreateUser()
    }
}

extension PasswordsViewController {
    fileprivate func preparePasswordTextField() {
        passwordTextField.placeholder = "Password"
        passwordTextField.isClearIconButtonEnabled = true
    }
    fileprivate func prepareRetypePasswordTextField() {
        retypePasswordTextField.placeholder = "Retype Password"
        retypePasswordTextField.isClearIconButtonEnabled = true
    }
}
