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
import MaterialComponents.MDCProgressView

class BirthdaySexViewController: UIViewController, BindableType {
    
    var sexPickerView: UIPickerView!
    var datePickerView: UIDatePicker!
    let disposeBag = DisposeBag()
    var viewModel: BirthdaySexViewModel!
    var progressView: MDCProgressView!

    @IBOutlet weak var birthdayTextField: TextField!
    @IBOutlet weak var sexTextField: TextField!
    @IBOutlet weak var nextScreenButton: UIButton!
    var navBackButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareBirthdayTextField()
        prepareSexTextField()
        prepareDatePickerView()
        prepareSexPickerView()
        prepareNavigationBackButton()
        prepareProgressView()
        prepareNextScreenButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = .moonBlue
        self.navigationController?.navigationBar.backgroundColor = .moonBlue
    }
    
    func bindViewModel() {
        
        sexPickerView.rx.itemSelected.bind(to: viewModel.sex).addDisposableTo(disposeBag)
        datePickerView.rx.date.bind(to: viewModel.birthday).addDisposableTo(disposeBag)
        
        viewModel.birthdayString.bind(to: birthdayTextField.rx.text).addDisposableTo(disposeBag)
        viewModel.sexString.bind(to: sexTextField.rx.text).addDisposableTo(disposeBag)
        
        nextScreenButton.rx.action = viewModel.nextSignUpScreen()
        navBackButton.rx.action = viewModel.onBack()
        
    }

}

extension BirthdaySexViewController {
    fileprivate func prepareBirthdayTextField() {
        birthdayTextField.placeholder = "Birthday"
        birthdayTextField.detail = "You must be 18 years old or older"
        birthdayTextField.placeholderActiveColor = .moonBlue
        birthdayTextField.dividerActiveColor = .moonBlue
        birthdayTextField.dividerNormalColor = .moonBlue
        
        let leftView = UIImageView()
        leftView.image = #imageLiteral(resourceName: "birthdayIcon")
        leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
        leftView.tintColor = .lightGray
        
        birthdayTextField.leftView = leftView
        birthdayTextField.leftViewActiveColor = .moonBlue
    }
    
    fileprivate func prepareSexTextField() {
        sexTextField.placeholder = "Sex"
        sexTextField.placeholderActiveColor = .moonBlue
        sexTextField.dividerActiveColor = .moonBlue
        sexTextField.dividerNormalColor = .moonBlue
        
        let leftView = UIImageView()
        leftView.image = #imageLiteral(resourceName: "sexIcon")
        leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
        leftView.tintColor = .lightGray
        
        sexTextField.leftView = leftView
        sexTextField.leftViewActiveColor = .moonBlue
    }
    
    fileprivate func prepareSexPickerView() {
        sexPickerView = UIPickerView()
        sexPickerView.dataSource = self
        sexPickerView.delegate = self
        
        sexTextField.rx
            .controlEvent(.editingDidBegin)
            .subscribe(onNext: {
                self.sexTextField.inputView = self.sexPickerView
            })
            .addDisposableTo(disposeBag)
    }
    
    fileprivate func prepareDatePickerView() {
        datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        
        birthdayTextField.rx
            .controlEvent(.editingDidBegin)
            .subscribe(onNext: {
                self.birthdayTextField.inputView = self.datePickerView
            })
            .addDisposableTo(disposeBag)
    }
    
    fileprivate func prepareNavigationBackButton() {
        navBackButton = UIBarButtonItem()
        navBackButton.image = Icon.cm.arrowBack
        navBackButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = navBackButton
    }
    
    fileprivate func prepareNextScreenButton() {
        
        let nextArrow = UIImage(cgImage: (Icon.cm.arrowBack?.cgImage)!, scale: 1.5, orientation: UIImageOrientation.down)
        
        nextScreenButton.backgroundColor = .moonBlue
        nextScreenButton.setTitle("", for: .normal)
        nextScreenButton.tintColor = .white
        nextScreenButton.layer.cornerRadius = 5
        nextScreenButton.setBackgroundImage(nextArrow, for: .normal)
        
    }
    
    fileprivate func prepareProgressView() {
        
        progressView = MDCProgressView()
        progressView.progress = 0.25
        progressView.trackTintColor = .moonGreenLight
        progressView.progressTintColor = .moonGreen
        
        let progressViewHeight = CGFloat(3)
        progressView.setHidden(false, animated: true)
        progressView.frame = CGRect(x: 0, y: 65, width: view.bounds.width, height: progressViewHeight)
        view.addSubview(progressView)
        
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