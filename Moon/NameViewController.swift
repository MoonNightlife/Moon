//
//  NameViewController.swift
//  Moon
//
//  Created by Evan Noble on 5/31/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import RxCocoa
import RxSwift
import Action

class NameViewController: UIViewController, BindableType {
    
    var viewModel: NameViewModel!
    let disposeBag = DisposeBag()

    @IBOutlet weak var lastNameTextField: TextField!
    @IBOutlet weak var firstNameTextField: TextField!
    @IBOutlet weak var nextScreenButton: UIButton!
    var navBackButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareFirstNameTextField()
        prepareLastNameTextField()
        prepareNavigationBackButton()
    }
    
    func bindViewModel() {
        firstNameTextField.rx.textInput.text.orEmpty.bind(to: viewModel.firstName).addDisposableTo(disposeBag)
        lastNameTextField.rx.textInput.text.orEmpty.bind(to: viewModel.lastName).addDisposableTo(disposeBag)
        nextScreenButton.rx.action = viewModel.nextSignUpScreen()
        navBackButton.rx.action = viewModel.onBack()
        
        viewModel.dataValid
            .subscribe(onNext: { [unowned self] (allValid) in
                self.changeNextButton(valid: allValid)
            })
            .addDisposableTo(disposeBag)
    }
    
    fileprivate func changeNextButton(valid: Bool) {
        nextScreenButton.isUserInteractionEnabled = valid
        switch valid {
        case true:
            nextScreenButton.setTitleColor(.moonGreen, for: .normal)
        case false:
            nextScreenButton.setTitleColor(.moonRed, for: .normal)
        }
    }

}

extension NameViewController {
    
    fileprivate func prepareFirstNameTextField() {
        firstNameTextField.placeholder = "First Name"
        firstNameTextField.isClearIconButtonEnabled = true
        
        let leftView = UIImageView()
        leftView.image = Icon.cm.audio
        firstNameTextField.leftView = leftView
    }
    
    fileprivate func prepareLastNameTextField() {
        lastNameTextField.placeholder = "Last Name"
        lastNameTextField.isClearIconButtonEnabled = true
        
        let leftView = UIImageView()
        leftView.image = Icon.cm.audio
        lastNameTextField.leftView = leftView
    }
    
    fileprivate func prepareNavigationBackButton() {
        navBackButton = UIBarButtonItem()
        navBackButton.title = "Back"
        self.navigationItem.leftBarButtonItem = navBackButton
    }

}
