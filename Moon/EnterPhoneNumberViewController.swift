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

class EnterPhoneNumberViewController: UIViewController, BindableType {

    var viewModel: EnterPhoneNumberViewModel!
    var navBackButton: UIBarButtonItem!
    private let bag = DisposeBag()
    
    @IBOutlet weak var changeCountryCodeButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var sendCodeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBackButton()
    }
    
    func bindViewModel() {
        changeCountryCodeButton.rx.action = viewModel.editCountryCode()
        sendCodeButton.rx.action = viewModel.onShowEnterCode()
        
        phoneNumberTextField.rx.textInput.text.orEmpty.bind(to: viewModel.phoneNumber).addDisposableTo(bag)
        viewModel.phoneNumberString.bind(to: phoneNumberTextField.rx.text).addDisposableTo(bag)
        
    }
    
    fileprivate func prepareNavigationBackButton() {
        navBackButton = UIBarButtonItem()
        navBackButton.image = Icon.cm.arrowBack
        navBackButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = navBackButton
    }

}

extension Reactive where Base: UIButton{
    
}
