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
        passwordTextField.rx.textInput.text.orEmpty.bind(to: viewModel.passwordText).addDisposableTo(disposeBag)
        retypePasswordTextField.rx.textInput.text.orEmpty.bind(to: viewModel.retypePasswordText).addDisposableTo(disposeBag)
        
        viewModel.showAcceptablePasswordError
            .subscribe(onNext: { [unowned self] show in
                self.passwordTextField.isErrorRevealed = show
            })
            .addDisposableTo(disposeBag)
        
        viewModel.showPasswordsMatchError
            .subscribe(onNext: { [unowned self] show in
                self.retypePasswordTextField.isErrorRevealed = show
            })
            .addDisposableTo(disposeBag)
        
        viewModel.allValid
            .subscribe(onNext: { [unowned self] (allValid) in
                self.changeNextButton(valid: allValid)
            })
            .addDisposableTo(disposeBag)
    }
    
    fileprivate func changeNextButton(valid: Bool) {
        doneButton.isUserInteractionEnabled = valid
        switch valid {
        case true:
            doneButton.setTitleColor(.moonGreen, for: .normal)
        case false:
            doneButton.setTitleColor(.moonRed, for: .normal)
        }
    }
}

extension PasswordsViewController {
    fileprivate func preparePasswordTextField() {
        passwordTextField.placeholder = "Password"
        passwordTextField.detail = "Invalid Password"
        passwordTextField.isClearIconButtonEnabled = true
    }
    fileprivate func prepareRetypePasswordTextField() {
        retypePasswordTextField.placeholder = "Retype Password"
        retypePasswordTextField.detail = "Passwords Do Not Match"
        retypePasswordTextField.isClearIconButtonEnabled = true
    }
}
