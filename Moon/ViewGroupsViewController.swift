//
//  ViewGroupsViewController.swift
//  Moon
//
//  Created by Evan Noble on 7/23/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import MaterialComponents
import Material

class ViewGroupsViewController: UIViewController, BindableType {
    
    // MARK: - Global
    var viewModel: ViewGroupsViewModel!

    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var viewActivity: UIButton!
    @IBOutlet weak var create: MDCFloatingButton!
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareCreateButton()
    }

    func bindViewModel() {
        viewButton.rx.action = viewModel.onManageGroup()
        viewActivity.rx.action = viewModel.onViewActivity()
        create.rx.action = viewModel.onCreate()
    }
    
    func prepareCreateButton() {
        create.backgroundColor = .moonGrey
        create.setBackgroundColor(.moonGrey, for: .normal)
        create.setImage(Icon.add, for: .normal)
        create.tintColor = .moonGreen
        
    }

}
