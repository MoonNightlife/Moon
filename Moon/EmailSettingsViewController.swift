//
//  EmailSettingsViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/8/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Material
import Action
import SwiftOverlays

class EmailSettingsViewController: UIViewController, BindableType {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var emailField: ErrorTextField!
    var viewModel: EmailSettingsViewModel!
    var navBackButton: UIBarButtonItem!
    var bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBackButton()
        prepareEmailTextField()
        prepareSaveButton()
    }

    func bindViewModel() {
        navBackButton.rx.action = viewModel.onBack()
        
        let saveAction = viewModel.onUpdateEmail()
        saveButton.rx.action = saveAction
        
        saveAction.executing
            .do(onNext: { [weak self] inProgress in
                if inProgress {
                    self?.showWaitOverlay()
                } else {
                    self?.removeAllOverlays()
                }
            })
            .subscribe()
            .addDisposableTo(bag)
        
        emailField.rx.textInput.text.bind(to: viewModel.newEmailAddress).addDisposableTo(bag)
        
        viewModel.showEmailError.bind(to: emailField.rx.isErrorRevealed).addDisposableTo(bag)
    }

    fileprivate func prepareNavigationBackButton() {
        navBackButton = UIBarButtonItem()
        navBackButton.image = Icon.cm.arrowBack
        navBackButton.tintColor = .lightGray
        self.navigationItem.leftBarButtonItem = navBackButton
    }
    
    fileprivate func prepareSaveButton() {
        saveButton.backgroundColor = .moonGreen
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 5
    }
    
    fileprivate func prepareEmailTextField() {
        emailField.placeholder = "Email"
        emailField.detail = "Invalid Email"
        emailField.isClearIconButtonEnabled = true
        emailField.placeholderActiveColor = .moonGreen
        emailField.dividerActiveColor = .moonGreen
        emailField.dividerNormalColor = .moonGreen
        
        let leftView = UIImageView()
        leftView.image = #imageLiteral(resourceName: "emailIcon")
        leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
        leftView.tintColor = .lightGray
        
        emailField.leftView = leftView
        emailField.leftViewActiveColor = .moonGreen
        
    }
}
