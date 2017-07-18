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
import SwiftOverlays

class EnterCodeViewController: UIViewController, BindableType {

    @IBOutlet weak var cancelButton: UIButton!
    var viewModel: EnterCodeViewModel!
    private let bag = DisposeBag()
    
    @IBOutlet weak var codeTextField: TextField!
    @IBOutlet weak var enterCodeButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareCancelButton()
        prepareInfoLabel()
        prepareEnterCodeButton()
        prepareCodeTextField()
    }

    func bindViewModel() {
        cancelButton.rx.action = viewModel.onBack()
        
        let checkCodeAction = viewModel.onCheckCode()
        enterCodeButton.rx.action = checkCodeAction
        
        checkCodeAction.executing
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
            })
            .addDisposableTo(bag)
        
        checkCodeAction.errors
            .subscribe(onNext: { [weak self] error in
                if case let .underlyingError(error) = error {
                    self?.showErrorAlert(message: error.localizedDescription)
                }
            })
            .addDisposableTo(bag)
        
        codeTextField.rx.textInput.text.orEmpty.bind(to: viewModel.code).addDisposableTo(bag)
        viewModel.enableCheckCodeButton.bind(to: enterCodeButton.rx.isEnabled).addDisposableTo(bag)
        viewModel.codeText.bind(to: codeTextField.rx.text).addDisposableTo(bag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    fileprivate func prepareCancelButton() {
        cancelButton.setImage(Icon.cm.close?.tint(with: .moonRed), for: .normal)
    }
    
    fileprivate func prepareEnterCodeButton() {
        enterCodeButton.backgroundColor = .moonGreen
        enterCodeButton.tintColor = .white
        enterCodeButton.layer.cornerRadius = 5
    }
    
    fileprivate func prepareCodeTextField() {
        codeTextField.placeholder = "Code"
        codeTextField.keyboardType = UIKeyboardType.numberPad
        codeTextField.isClearIconButtonEnabled = true
        codeTextField.placeholderActiveColor = .moonGreen
        codeTextField.dividerActiveColor = .moonGreen
        codeTextField.dividerNormalColor = .moonGreen
        codeTextField.placeholderNormalColor = .lightGray
    }
    
    fileprivate func prepareInfoLabel() {
        infoLabel.textColor = .lightGray
    }

}
