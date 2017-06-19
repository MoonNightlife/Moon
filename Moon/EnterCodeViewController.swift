//
//  EnterCodeViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/15/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import RxCocoa
import RxSwift

class EnterCodeViewController: UIViewController, BindableType {

    var viewModel: EnterCodeViewModel!
    var navBackButton: UIBarButtonItem!
    private let bag = DisposeBag()
    
    @IBOutlet weak var codeTextField: TextField!
    @IBOutlet weak var enterCodeButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var reSendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBackButton()
        prepareInfoLabel()
        prepareReSendButton()
        prepareEnterCodeButton()
        prepareCodeTextField()
    }

    func bindViewModel() {
        navBackButton.rx.action = viewModel.onBack()
        
        codeTextField.rx.textInput.text.orEmpty.bind(to: viewModel.code).addDisposableTo(bag)
        viewModel.enableCheckCodeButton.bind(to: enterCodeButton.rx.isEnabled).addDisposableTo(bag)
        viewModel.codeText.bind(to: codeTextField.rx.text).addDisposableTo(bag)
    }
    
    fileprivate func prepareNavigationBackButton() {
        navBackButton = UIBarButtonItem()
        navBackButton.image = Icon.cm.arrowBack
        navBackButton.tintColor = .lightGray
        self.navigationItem.leftBarButtonItem = navBackButton
    }
    
    fileprivate func prepareEnterCodeButton() {
        enterCodeButton.backgroundColor = .moonGreen
        enterCodeButton.tintColor = .white
        enterCodeButton.layer.cornerRadius = 5
    }
    
    fileprivate func prepareCodeTextField() {
        codeTextField.placeholder = "Code"
        codeTextField.isClearIconButtonEnabled = true
        codeTextField.placeholderActiveColor = .moonGreen
        codeTextField.dividerActiveColor = .moonGreen
        codeTextField.dividerNormalColor = .moonGreen
        codeTextField.placeholderNormalColor = .lightGray    }
    
    fileprivate func prepareInfoLabel() {
        infoLabel.textColor = .lightGray
    }
    
    fileprivate func prepareReSendButton() {
        reSendButton.backgroundColor = .moonBlue
        reSendButton.tintColor = .white
        reSendButton.layer.cornerRadius = 5
    }

}
