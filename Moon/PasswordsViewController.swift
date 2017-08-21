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
import MaterialComponents.MDCProgressView
import SwiftOverlays

class PasswordsViewController: UIViewController, BindableType {

    let disposeBag = DisposeBag()
    var viewModel: PasswordsViewModel!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var retypePasswordTextField: ErrorTextField!
    @IBOutlet weak var passwordTextField: ErrorTextField!
    var navBackButton: UIBarButtonItem!
    var progressView: MDCProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        preparePasswordTextField()
        prepareRetypePasswordTextField()
        prepareNavigationBackButton()
        prepareProgressView()
        prepareDoneButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = .moonGreen
        self.navigationController?.navigationBar.backgroundColor = .moonGreen
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        progressView.setProgress(0.75, animated: true, completion: nil)
    }

    func bindViewModel() {
        passwordTextField.rx.textInput.text.orEmpty.bind(to: viewModel.passwordText).addDisposableTo(disposeBag)
        retypePasswordTextField.rx.textInput.text.orEmpty.bind(to: viewModel.retypePasswordText).addDisposableTo(disposeBag)
        
        viewModel.showAcceptablePasswordError.bind(to: passwordTextField.rx.isErrorRevealed).addDisposableTo(disposeBag)
        viewModel.showPasswordsMatchError.bind(to: retypePasswordTextField.rx.isErrorRevealed).addDisposableTo(disposeBag)
        
        viewModel.allValid.bind(to: doneButton.rx.isEnabled).addDisposableTo(disposeBag)
        
        let createUserAction = viewModel.createUser()
        doneButton.rx.action = createUserAction
        
        createUserAction.executing.do(onNext: {
            if $0 {
                SwiftOverlays.showBlockingWaitOverlayWithText("Creating Account")
            } else {
                SwiftOverlays.removeAllBlockingOverlays()
            }
        }).subscribe().addDisposableTo(disposeBag)
        
        createUserAction.errors.subscribe(onNext: { [weak self] actionError in
            if case let .underlyingError(error) = actionError {
                self?.showErrorAlert(message: (error as NSError).localizedDescription)
            }
        }).addDisposableTo(disposeBag)

        navBackButton.rx.action = viewModel.onBack()
    }
    
}

extension PasswordsViewController {
    fileprivate func preparePasswordTextField() {
        passwordTextField.placeholder = "Password"
        passwordTextField.detail = "Invalid Password"
        passwordTextField.isClearIconButtonEnabled = true
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholderActiveColor = .moonGreen
        passwordTextField.dividerActiveColor = .moonGreen
        passwordTextField.dividerNormalColor = .moonGreen
        
        let leftView = UIImageView()
        leftView.image = #imageLiteral(resourceName: "passwordIcon")
        leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
        leftView.tintColor = .lightGray
        
        passwordTextField.leftView = leftView
        passwordTextField.leftViewActiveColor = .moonGreen
    }
    
    fileprivate func prepareRetypePasswordTextField() {
        retypePasswordTextField.placeholder = "Retype Password"
        retypePasswordTextField.detail = "Passwords Do Not Match"
        retypePasswordTextField.isClearIconButtonEnabled = true
        retypePasswordTextField.isSecureTextEntry = true
        retypePasswordTextField.placeholderActiveColor = .moonGreen
        retypePasswordTextField.dividerActiveColor = .moonGreen
        retypePasswordTextField.dividerNormalColor = .moonGreen
        
        let leftView = UIImageView()
        leftView.image = #imageLiteral(resourceName: "passwordIcon")
        leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
        leftView.tintColor = .lightGray
        
        retypePasswordTextField.leftView = leftView
        retypePasswordTextField.leftViewActiveColor = .moonGreen
    }
    
    fileprivate func prepareNavigationBackButton() {
        self.navigationItem.hidesBackButton = true
        navBackButton = UIBarButtonItem()
        navBackButton.image = Icon.cm.arrowBack
        navBackButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = navBackButton
        
    }
    
    fileprivate func prepareDoneButton() {
        doneButton.backgroundColor = .moonGreen
        doneButton.setTitle("Finish", for: .normal)
        doneButton.titleLabel?.font = UIFont(name: "Roboto", size: 14)
        doneButton.tintColor = .white
        doneButton.layer.cornerRadius = 5
        
    }
    
    fileprivate func prepareProgressView() {
        
        progressView = MDCProgressView()
        progressView.progress = 0.5
        progressView.trackTintColor = .moonGreenLight
        progressView.progressTintColor = .moonGreen
        
        let progressViewHeight = CGFloat(3)
        progressView.setHidden(false, animated: true)
        progressView.frame = CGRect(x: 0, y: 65, width: view.bounds.width, height: progressViewHeight)
        view.addSubview(progressView)
        
    }
}
