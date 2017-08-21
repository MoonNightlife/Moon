//
//  SettingsViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/8/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import RxCocoa
import Material
import SwiftOverlays
import RxSwift

class SettingsViewController: UITableViewController, BindableType {
    
    var viewModel: SettingsViewModel!
    private let disposeBag = DisposeBag()
    var navBackButton: UIBarButtonItem!

    @IBOutlet weak var usernameCell: UITableViewCell!
    @IBOutlet weak var phoneNumberCell: UITableViewCell!
    @IBOutlet weak var emailCell: UITableViewCell!
    @IBOutlet weak var privacySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.loadUserInfo.execute()
    }

    func bindViewModel() {
        navBackButton.rx.action = viewModel.onBack()
        
        if let usernameLabel = usernameCell.detailTextLabel,
            let emailLabel = emailCell.detailTextLabel,
            let phoneNumberLabel = phoneNumberCell.detailTextLabel {
            
            viewModel.username.bind(to: usernameLabel.rx.text).addDisposableTo(disposeBag)
            viewModel.email.bind(to: emailLabel.rx.text).addDisposableTo(disposeBag)
            viewModel.phoneNumber.bind(to: phoneNumberLabel.rx.text).addDisposableTo(disposeBag)
        }
        
        // Bind the initial state to the privacy switch
        viewModel.privacy.drive(privacySwitch.rx.isOn).addDisposableTo(disposeBag)
        // Call action on update privacy when switch changes
        privacySwitch.rx.bind(to: viewModel.updatePrivacy, controlEvent: privacySwitch.rx.controlEvent(.valueChanged)) {
            return $0.isOn
        }
        viewModel.updatePrivacy.executing.map(!).bind(to: privacySwitch.rx.isEnabled).addDisposableTo(disposeBag)
        viewModel.updatePrivacy.executionObservables
            .flatMap({
                // Must catch error or else the subscription will die
                return $0.do(onError: { [unowned self] _ in
                    self.privacySwitch.isOn = !self.privacySwitch.isOn
                    
                    let errorView = TopErrorMessage.instanceFromNib()
                    errorView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 25)
                    errorView.displayMessage = "Could not update privacy setting"
                    SwiftOverlays.showAnnoyingNotificationOnTopOfStatusBar(errorView, duration: 3.0)
                }).catchErrorJustReturn(())
            })
            .subscribe()
            .addDisposableTo(disposeBag)
        
        viewModel.loadingIndicator.asObservable()
            .subscribe(onNext: { [weak self] show in
                if show {
                    self?.showWaitOverlay()
                } else {
                    self?.removeAllOverlays()
                }
            })
            .addDisposableTo(disposeBag)
        
        self.tableView.rx.itemSelected
            .map(settingFrom)
            .filter({ $0 != nil })
            .map({ $0! })
            .subscribe(viewModel.showNextScreen.inputs)
            .addDisposableTo(disposeBag)
    }
    
    fileprivate func prepareNavigationBackButton() {
        self.navigationItem.hidesBackButton = true
        navBackButton = UIBarButtonItem()
        navBackButton.image = Icon.cm.arrowBack
        navBackButton.tintColor = .lightGray
        self.navigationItem.leftBarButtonItem = navBackButton
    }
    
    fileprivate func settingFrom(indexPath: IndexPath) -> Setting? {
        switch indexPath.section {
        case 0:
            guard let setting = SettingSections.MyAccount(rawValue: indexPath.row) else {
                return nil
            }
            return Setting.myAccount(option: setting)
        case 1:
            guard let setting = SettingSections.MoreInformation(rawValue: indexPath.row) else {
                return nil
            }
            return Setting.moreInformation(option: setting)
        case 2:
            guard let setting = SettingSections.AccountActions(rawValue: indexPath.row) else {
                return nil
            }
            return Setting.accountActions(option: setting)
        default: return nil
        }
    }

}
