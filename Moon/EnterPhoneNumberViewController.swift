//
//  EnterPhoneNumberViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/15/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import RxCocoa
import RxSwift
import SwiftOverlays

class EnterPhoneNumberViewController: UIViewController, BindableType {

    var viewModel: EnterPhoneNumberViewModel!
    private let bag = DisposeBag()
    
    @IBOutlet weak var changeCountryCodeButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: TextField!
    @IBOutlet weak var sendCodeButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareCancelButton()
        prepareSendCodeButton()
        preparePhoneNumberTextField()
        prepareCountryCodeButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    func bindViewModel() {
        cancelButton.rx.action = viewModel.onBack()
        
        let sendCodeAction = viewModel.onSendCode()
        
        sendCodeButton.rx.action = sendCodeAction
        
        sendCodeAction.executing
            .do(onNext: { [weak self] executing in
                if executing {
                    self?.view.endEditing(true)
                }
            })
            .subscribe(onNext: {
            if $0 {
                SwiftOverlays.showBlockingWaitOverlay()
            } else {
                SwiftOverlays.removeAllBlockingOverlays()
            }
        }).addDisposableTo(bag)
        
        sendCodeAction.errors.subscribe(onNext: { [weak self] error in
            if case let .underlyingError(error) = error {
                self?.showErrorAlert(message: error.localizedDescription)
            }
        }).addDisposableTo(bag)
        
        changeCountryCodeButton.rx.action = viewModel.editCountryCode()
        viewModel.enableEnterCode.bind(to: sendCodeButton.rx.isEnabled).addDisposableTo(bag)
        
        phoneNumberTextField.rx.textInput.text.orEmpty.bind(to: viewModel.phoneNumber).addDisposableTo(bag)
        viewModel.phoneNumberString.bind(to: phoneNumberTextField.rx.text).addDisposableTo(bag)
        
        viewModel.countryCode.asObservable().subscribe(onNext: { [weak self] code in
            let title = code.description
            self?.changeCountryCodeButton.setTitle(title, for: .normal)
        })
        .addDisposableTo(bag)
        
    }
    
    fileprivate func prepareCancelButton() {
        cancelButton.setImage(Icon.cm.close?.tint(with: .moonRed), for: .normal)
    }
    
    fileprivate func preparePhoneNumberTextField() {
        phoneNumberTextField.placeholder = "Phone Number"
        phoneNumberTextField.isClearIconButtonEnabled = true
        phoneNumberTextField.placeholderActiveColor = .moonBlue
        phoneNumberTextField.dividerActiveColor = .moonBlue
        phoneNumberTextField.dividerNormalColor = .moonBlue
        phoneNumberTextField.placeholderNormalColor = .lightGray
    }
    
    fileprivate func prepareSendCodeButton() {
        sendCodeButton.backgroundColor = .moonGreen
        sendCodeButton.tintColor = .white
        sendCodeButton.layer.cornerRadius = 5
    }
    
    fileprivate func prepareCountryCodeButton() {
        changeCountryCodeButton.tintColor = .moonBlue
    }
}

extension Reactive where Base: UIButton {
    
}
