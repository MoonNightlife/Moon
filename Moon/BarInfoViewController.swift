//
//  BarInfoViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/12/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Action

class BarInfoViewController: UIViewController, BindableType {

    var viewModel: BarInfoViewModel!
    private let bag = DisposeBag()
    
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func bindViewModel() {
        backButton.rx.action = viewModel.onBack()
        websiteButton.rx.action = viewModel.onViewWebsite()
        phoneNumberButton.rx.action = viewModel.onCall()
        addressButton.rx.action = viewModel.onGetDirections()
        
        viewModel.address.drive(addressButton.rx.title()).addDisposableTo(bag)
        viewModel.phoneNumber.drive(phoneNumberButton.rx.title()).addDisposableTo(bag)
        viewModel.website.drive(websiteButton.rx.title()).addDisposableTo(bag)
    }

}
