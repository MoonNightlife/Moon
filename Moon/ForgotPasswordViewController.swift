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
        prepareEmailTextField()
        prepareSendEmailButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = .moonGreen
        self.navigationController?.navigationBar.backgroundColor = .moonGreen
    }
    
    func bindViewModel() {
        navBackButton.rx.action = viewModel.onBack()
        sendEmailButton.rx.action = viewModel.onSendPasswordReset()
        emailTextField.rx.textInput.text.bind(to: viewModel.email).addDisposableTo(bag)
    }
    
    fileprivate func prepareSendEmailButton() {
        sendEmailButton.backgroundColor = .moonGreen
        sendEmailButton.setTitle("Submit", for: .normal)
        sendEmailButton.tintColor = .white
        sendEmailButton.layer.cornerRadius = 5
    }
    
    fileprivate func prepareNavigationBackButton() {
        navBackButton = UIBarButtonItem()
        navBackButton.image = Icon.cm.arrowBack
        navBackButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = navBackButton
    }
    
    fileprivate func prepareEmailTextField() {
        emailTextField.placeholder = "Email"
        emailTextField.isClearIconButtonEnabled = true
        emailTextField.placeholderActiveColor = .moonGreen
        emailTextField.dividerActiveColor = .moonGreen
        emailTextField.dividerNormalColor = .moonGreen
        
        let leftView = UIImageView()
        leftView.image = #imageLiteral(resourceName: "emailIcon")
        leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
        leftView.tintColor = .lightGray
        
        emailTextField.leftView = leftView
        emailTextField.leftViewActiveColor = .moonGreen
    }

}
