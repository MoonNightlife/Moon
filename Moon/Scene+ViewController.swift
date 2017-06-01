//
//  Scene+ViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/1/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit

//swiftlint:disable force_cast
extension SignUpScene {
    func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        switch self {
        case .birthdaySex(let viewModel):
            var vc = storyboard.instantiateViewController(withIdentifier: "BirthdaySex") as! BirthdaySexViewController
            vc.bindViewModel(to: viewModel)
            return vc    
        case .emailUsername(let viewModel):
            var vc = storyboard.instantiateViewController(withIdentifier: "EmailUsername") as! EmailUsernameViewController
            vc.bindViewModel(to: viewModel)
            return vc
        case .name(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "Name") as! UINavigationController
            var vc = nc.viewControllers.first as! NameViewController
            vc.bindViewModel(to: viewModel)
            return nc
        case .passwords(let viewModel):
            var vc = storyboard.instantiateViewController(withIdentifier: "Passwords") as! PasswordsViewController
            vc.bindViewModel(to: viewModel)
            return vc
        }
    }
}
