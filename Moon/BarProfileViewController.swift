//
//  BarProfileViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/8/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit

class BarProfileViewController: UIViewController, BindableType {

    @IBOutlet weak var backButton: UIBarButtonItem!
    var viewModel: BarProfileViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func bindViewModel() {
        backButton.rx.action = viewModel.onBack()
    }

}
