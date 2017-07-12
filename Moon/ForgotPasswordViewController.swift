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
import SwiftOverlays

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
        
        emailTextField.rx.textInput.text.bind(to: viewModel.email).addDisposableTo(bag)
        
        let sendReset = viewModel.onSendPasswordReset()
        sendEmailButton.rx.action = sendReset
        sendReset.executing.do(onNext: {
            if $0 {
                SwiftOverlays.showBlockingWaitOverlayWithText("Sending Email")
            } else {
                SwiftOverlays.removeAllBlockingOverlays()
            }
        }).subscribe().addDisposableTo(bag)
        
        sendReset.errors.subscribe(onNext: { [weak self] actionError in
            if case let .underlyingError(error) = actionError {
                self?.showErrorAlert(message: (error as NSError).localizedDescription)
            }
        }).addDisposableTo(bag)
 
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
