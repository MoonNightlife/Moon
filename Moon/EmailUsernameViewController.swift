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

class EmailUsernameViewController: UIViewController {
    
    var viewModel: EmailUsernameViewModel!
    let disposeBag = DisposeBag()

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var usernameTextField: ErrorTextField!
    @IBOutlet weak var emailTextField: ErrorTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareEmailTextField()
        prepareUsernameTextField()
        prepareNextButton()
    }

}

extension EmailUsernameViewController {
    fileprivate func prepareUsernameTextField() {
        usernameTextField.placeholder = "Username"
        usernameTextField.detail = "Invailid Username"
        usernameTextField.isClearIconButtonEnabled = true
        
        usernameTextField.rx.textInput.text.bind(to: viewModel.email).addDisposableTo(disposeBag)
        viewModel.usernameValid
            .subscribe(onNext: { (isValid) in
                self.usernameTextField.isErrorRevealed = !isValid
            })
            .addDisposableTo(disposeBag)
    }
    fileprivate func prepareEmailTextField() {
        emailTextField.placeholder = "Email"
        emailTextField.isClearIconButtonEnabled = true
        emailTextField.rx.textInput.text.bind(to: viewModel.username).addDisposableTo(disposeBag)
    }
    fileprivate func prepareNextButton() {
        viewModel.allFieldsValid.bind(to: nextButton.rx.isEnabled).addDisposableTo(disposeBag)
    }
}
