//
//  NameSettingsViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/8/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Material

class NameSettingsViewController: UIViewController, BindableType {
    @IBOutlet weak var firstName: TextField!
    @IBOutlet weak var lastName: TextField!
    @IBOutlet weak var saveButton: UIButton!
    
    private let bag = DisposeBag()
    var viewModel: NameSettingsViewModel!
    var navBackButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBackButton()
        prepareFirstNameTextField()
        prepareLastNameTextField()
    }

    func bindViewModel() {
        navBackButton.rx.action = viewModel.onBack()
        saveButton.rx.action = viewModel.onSave()
        
        firstName.rx.textInput.text.bind(to: viewModel.firstNameText).addDisposableTo(bag)
        lastName.rx.textInput.text.bind(to: viewModel.lastNameText).addDisposableTo(bag)
    }
    
    fileprivate func prepareNavigationBackButton() {
        navBackButton = UIBarButtonItem()
        navBackButton.image = Icon.cm.arrowBack
        navBackButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = navBackButton
    }
    
    fileprivate func prepareFirstNameTextField() {
        firstName.placeholder = "First Name"
        firstName.isClearIconButtonEnabled = true
    }
    
    fileprivate func prepareLastNameTextField() {
        lastName.placeholder = "Last Name"
        lastName.isClearIconButtonEnabled = true
    }

}
