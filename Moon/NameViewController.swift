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

class NameViewController: UIViewController {
    
    var viewModel: NameViewModel!
    let disposeBag = DisposeBag()

    @IBOutlet weak var lastNameTextField: TextField!
    @IBOutlet weak var firstNameTextField: TextField!
    @IBOutlet weak var nextScreenButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // this needs to be created by the login screen view model
        viewModel = NameViewModel()
        viewModel.validationUtility = ValidationUtility()
        viewModel.newUser = NewUser()
        
        prepareFirstNameTextField()
        prepareLastNameTextField()
        prepareNextScreenButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BirthdaySexViewController {
            vc.viewModel = viewModel.createBirthdaySexViewModel()
        }
    }

}

extension NameViewController {
    fileprivate func prepareNextScreenButton() {
        viewModel.dataValid.bind(to: nextScreenButton.rx.isEnabled).addDisposableTo(disposeBag)
    }
    
    fileprivate func prepareFirstNameTextField() {
        firstNameTextField.placeholder = "First Name"
        firstNameTextField.isClearIconButtonEnabled = true
        firstNameTextField.rx.textInput.text.bind(to: viewModel.firstName).addDisposableTo(disposeBag)
        
        let leftView = UIImageView()
        leftView.image = Icon.cm.audio
        firstNameTextField.leftView = leftView
    }
    
    fileprivate func prepareLastNameTextField() {
        lastNameTextField.placeholder = "Last Name"
        lastNameTextField.isClearIconButtonEnabled = true
        lastNameTextField.rx.textInput.text.bind(to: viewModel.lastNmae).addDisposableTo(disposeBag)
        
        let leftView = UIImageView()
        leftView.image = Icon.cm.audio
        lastNameTextField.leftView = leftView
    }
}
