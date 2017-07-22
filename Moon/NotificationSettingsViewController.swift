//
//  NotificationSettingsViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/8/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Material
import RxOptional

class NotificationSettingsViewController: UIViewController, BindableType {
    
    var viewModel: NotificationSettingsViewModel!
    var navBackButton: UIBarButtonItem!
    var bag = DisposeBag()

    @IBOutlet weak var notificationSettingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBackButton()
    }

    func bindViewModel() {
        navBackButton.rx.action = viewModel.onBack()
        
        viewModel.notificationSettings.asObservable().filterNil().take(1).bind(to: notificationSettingsTableView.rx.items(cellIdentifier: "NotificationSettingCell")) { [weak self] _, model, cell in
            
            if let cell = cell as? NotificationTableViewCell,
                let activated = model.activated,
                let name = model.name {
                
                cell.title.text = model.displayName
                cell.enableSwitch.isOn = activated
                cell.enableSwitch.rx.controlEvent(UIControlEvents.valueChanged)
                    .subscribe(onNext: { [weak self] _ in
                        self?.viewModel.onUpdateSetting(nameOfSetting: name)
                    })
                    .addDisposableTo(cell.bag)
            }
            
        }.addDisposableTo(bag)
    }

    fileprivate func prepareNavigationBackButton() {
        navBackButton = UIBarButtonItem()
        navBackButton.image = Icon.cm.arrowBack
        navBackButton.tintColor = .lightGray
        self.navigationItem.leftBarButtonItem = navBackButton
    }
}
