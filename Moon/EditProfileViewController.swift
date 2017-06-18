//
//  EditProfileViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/18/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material
import RxSwift
import Action

class EditProfileViewController: UIViewController, BindableType {

    var viewModel: EditProfileViewModel!
    var cancelButton: UIBarButtonItem!
    var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationButtons()
    }
    
    func bindViewModel() {
        cancelButton.rx.action = viewModel.onBack()
        saveButton.rx.action = viewModel.onSave()
    }
    
    func prepareNavigationButtons() {
        cancelButton = UIBarButtonItem()
        cancelButton.image = Icon.cm.close
        cancelButton.tintColor = UIColor.moonRed
        self.navigationItem.leftBarButtonItem = cancelButton
        
        saveButton = UIBarButtonItem()
        saveButton.image = Icon.cm.check
        saveButton.tintColor = UIColor.moonGreen
        self.navigationItem.rightBarButtonItem = saveButton
    }

}
