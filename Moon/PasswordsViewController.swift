//
//  PasswordsViewController.swift
//  Moon
//
//  Created by Evan Noble on 5/31/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material

class PasswordsViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!

    @IBOutlet weak var retypePasswordTextField: ErrorTextField!
    @IBOutlet weak var passwordTextField: ErrorTextField!
    @IBAction func doneButtonTapped(_ sender: Any) {
        print("Present Master View")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        preparePasswordTextField()
        prepareRetypePasswordTextField()
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
