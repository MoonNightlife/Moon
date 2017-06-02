//
//  ForgotPasswordViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/2/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import RxSwift
import RxCocoa

class ForgotPasswordViewController: UIViewController, BindableType {
    
    var viewModel: ForgotPasswordViewModel!
    private let bag = DisposeBag()

    var navBackButton: UIBarButtonItem!
    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var sendEmailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBackButton()
    }
    
    func bindViewModel() {
        navBackButton.rx.action = viewModel.onBack()
        sendEmailButton.rx.action = viewModel.onSendPasswordReset()
        emailTextField.rx.textInput.text.bind(to: viewModel.email).addDisposableTo(bag)
    }
    
    fileprivate func prepareNavigationBackButton() {
        navBackButton = UIBarButtonItem()
        navBackButton.title = "Back"
        self.navigationItem.leftBarButtonItem = navBackButton
    }

}
