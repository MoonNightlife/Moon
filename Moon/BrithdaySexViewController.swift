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

class BirthdaySexViewController: UIViewController {
    
    var sexPickerView: UIPickerView!
    var datePickerView: UIDatePicker!
    let disposeBag = DisposeBag()
    var viewModel: BirthdaySexViewModel!

    @IBOutlet weak var birthdayTextField: TextField!
    @IBOutlet weak var sexTextField: TextField!
    @IBOutlet weak var nextScreenTextField: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareBirthdayTextField()
        prepareSexTextField()
        prepareDatePickerView()
        prepareSexPickerView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EmailUsernameViewController {
            vc.viewModel = viewModel.createEmailUsernameViewModel()
        }
    }

}

extension BirthdaySexViewController {
    fileprivate func prepareBirthdayTextField() {
        birthdayTextField.placeholder = "Birthday"
        
        birthdayTextField.rx
            .controlEvent(.editingDidBegin)
            .subscribe(onNext: {
                self.birthdayTextField.inputView = self.datePickerView
            })
            .addDisposableTo(disposeBag)
        
        viewModel.birthdayString.bind(to: birthdayTextField.rx.text).addDisposableTo(disposeBag)
    }
    
    fileprivate func prepareSexTextField() {
        sexTextField.placeholder = "Sex"
        
        sexTextField.rx
            .controlEvent(.editingDidBegin)
            .subscribe(onNext: {
                self.sexTextField.inputView = self.sexPickerView
            })
            .addDisposableTo(disposeBag)
        
        viewModel.sexString.bind(to: sexTextField.rx.text).addDisposableTo(disposeBag)
    }
    
    fileprivate func prepareSexPickerView() {
        sexPickerView = UIPickerView()
        sexPickerView.dataSource = self
        sexPickerView.delegate = self
        
        sexPickerView.rx.itemSelected.bind(to: viewModel.sex).addDisposableTo(disposeBag)
    }
    
    fileprivate func prepareDatePickerView() {
        datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        
        datePickerView.rx.date.bind(to: viewModel.birthday).addDisposableTo(disposeBag)
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
