//
//  BrithdaySexViewController.swift
//  Moon
//
//  Created by Evan Noble on 5/31/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import RxCocoa
import RxSwift

class BirthdaySexViewController: UIViewController, BindableType {
    
    var sexPickerView: UIPickerView!
    var datePickerView: UIDatePicker!
    let disposeBag = DisposeBag()
    var viewModel: BirthdaySexViewModel!

    @IBOutlet weak var birthdayTextField: TextField!
    @IBOutlet weak var sexTextField: TextField!
    @IBOutlet weak var nextScreenButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareBirthdayTextField()
        prepareSexTextField()
        prepareDatePickerView()
        prepareSexPickerView()
        prepareNextButton()
    }
    
    func bindViewModel() {
        
        birthdayTextField.rx
            .controlEvent(.editingDidBegin)
            .subscribe(onNext: {
                self.birthdayTextField.inputView = self.datePickerView
            })
            .addDisposableTo(disposeBag)
        
        sexTextField.rx
            .controlEvent(.editingDidBegin)
            .subscribe(onNext: {
                self.sexTextField.inputView = self.sexPickerView
            })
            .addDisposableTo(disposeBag)
        
        sexPickerView.rx.itemSelected.bind(to: viewModel.sex).addDisposableTo(disposeBag)
        datePickerView.rx.date.bind(to: viewModel.birthday).addDisposableTo(disposeBag)
        
        viewModel.birthdayString.bind(to: birthdayTextField.rx.text).addDisposableTo(disposeBag)
        viewModel.sexString.bind(to: sexTextField.rx.text).addDisposableTo(disposeBag)
        viewModel.validInfo
            .subscribe(onNext: { [unowned self] (allValid) in
                self.changeNextButton(valid: allValid)
            })
            .addDisposableTo(disposeBag)
        nextScreenButton.rx.action = viewModel.nextSignUpScreen()
        
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

extension BirthdaySexViewController {
    fileprivate func prepareBirthdayTextField() {
        birthdayTextField.placeholder = "Birthday"
    }
    
    fileprivate func prepareSexTextField() {
        sexTextField.placeholder = "Sex"
        
    }
    
    fileprivate func prepareSexPickerView() {
        sexPickerView = UIPickerView()
        sexPickerView.dataSource = self
        sexPickerView.delegate = self
    }
    
    fileprivate func prepareDatePickerView() {
        datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.maximumDate = Date()
    }
    
    fileprivate func prepareNextButton() {
        nextScreenButton.isEnabled = false
    }
}

extension BirthdaySexViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.sexPickerViewOptions.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.sexPickerViewOptions[row]
    }
}
