//
//  ProfileViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, BindableType {
    
    var viewModel: ProfileViewModel!

    @IBOutlet weak var dismissButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func bindViewModel() {
        dismissButton.rx.action = viewModel.onDismiss()
    }

}
