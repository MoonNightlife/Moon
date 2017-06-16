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
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var enterCodeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBackButton()
    }

    func bindViewModel() {
        
    }
    
    fileprivate func prepareNavigationBackButton() {
        navBackButton = UIBarButtonItem()
        navBackButton.image = Icon.cm.arrowBack
        navBackButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = navBackButton
    }

}
