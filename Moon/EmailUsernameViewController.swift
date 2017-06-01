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
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareEmailTextField()
        prepareUsernameTextField()
    }

    func bindViewModel() {
        usernameTextField.rx.textInput.text.bind(to: viewModel.username).addDisposableTo(disposeBag)
        emailTextField.rx.textInput.text.bind(to: viewModel.email).addDisposableTo(disposeBag)
        
        viewModel.allFieldsValid
            .subscribe(onNext: { [unowned self] (allValid) in
                self.changeNextButton(valid: allValid)
            })
            .addDisposableTo(disposeBag)
        
        nextButton.rx.action = viewModel.nextSignUpScreen()
        
        viewModel.showUsernameError
            .subscribe(onNext: { [unowned self] (show) in
                self.usernameTextField.isErrorRevealed = show
            })
            .addDisposableTo(disposeBag)
        
        viewModel.showEmailError
            .subscribe(onNext: { [unowned self] (show) in
                self.emailTextField.isErrorRevealed = show
            })
            .addDisposableTo(disposeBag)
    }
    
    fileprivate func changeNextButton(valid: Bool) {
        nextButton.isUserInteractionEnabled = valid
        switch valid {
        case true:
            nextButton.setTitleColor(.moonGreen, for: .normal)
        case false:
            nextButton.setTitleColor(.moonRed, for: .normal)
        }
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
}
