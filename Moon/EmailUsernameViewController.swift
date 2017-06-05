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
import MaterialComponents.MDCProgressView

class EmailUsernameViewController: UIViewController, BindableType {
    
    var viewModel: EmailUsernameViewModel!
    let disposeBag = DisposeBag()
    var progressView: MDCProgressView!

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var usernameTextField: ErrorTextField!
    @IBOutlet weak var emailTextField: ErrorTextField!
    var navBackButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareEmailTextField()
        prepareUsernameTextField()
        prepareNavigationBackButton()
        prepareNextScreenButton()
        prepareProgressView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = .moonRed
        self.navigationController?.navigationBar.backgroundColor = .moonRed
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
        usernameTextField.placeholderActiveColor = .moonRed
        usernameTextField.dividerActiveColor = .moonRed
        usernameTextField.dividerNormalColor = .moonRed
        
        let leftView = UIImageView()
        leftView.image = Icon.cm.pen
        usernameTextField.leftView = leftView
        usernameTextField.leftViewActiveColor = .moonRed
    }
    fileprivate func prepareEmailTextField() {
        emailTextField.placeholder = "Email"
        emailTextField.detail = "Invalid Email"
        emailTextField.isClearIconButtonEnabled = true
        emailTextField.placeholderActiveColor = .moonRed
        emailTextField.dividerActiveColor = .moonRed
        emailTextField.dividerNormalColor = .moonRed
        
        let leftView = UIImageView()
        leftView.image = #imageLiteral(resourceName: "emailIcon")
        leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
        leftView.tintColor = .lightGray
        
        emailTextField.leftView = leftView
        emailTextField.leftViewActiveColor = .moonRed
        
    }
    
    fileprivate func prepareNavigationBackButton() {
        navBackButton = UIBarButtonItem()
        navBackButton.image = Icon.cm.arrowBack
        navBackButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = navBackButton
        
    }
    
    fileprivate func prepareNextScreenButton() {
        
        let nextArrow = UIImage(cgImage: (Icon.cm.arrowBack?.cgImage)!, scale: 1.5, orientation: UIImageOrientation.down)
        
        nextButton.backgroundColor = .moonRed
        nextButton.setTitle("", for: .normal)
        nextButton.tintColor = .white
        nextButton.layer.cornerRadius = 5
        nextButton.setBackgroundImage(nextArrow, for: .normal)
        
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
