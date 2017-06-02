//
//  Scene+ViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/1/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit

extension Scene {
    func viewController() -> UIViewController {
        switch self {
        case .signUp(let scene):
            return scene.viewController()
        case .login(let scene):
            return scene.viewController()
        }
    }
}

//swiftlint:disable force_cast
extension SignUpScene {
    fileprivate func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        switch self {
        case .birthdaySex(let viewModel):
            //let nc = storyboard.instantiateViewController(withIdentifier: "BirthdaySex") as! UINavigationController
            //var vc = nc.viewControllers.first as! BirthdaySexViewController
            var vc = storyboard.instantiateViewController(withIdentifier: "BirthdaySex") as! BirthdaySexViewController
            vc.bindViewModel(to: viewModel)
            return vc    
        case .emailUsername(let viewModel):
            //let nc = storyboard.instantiateViewController(withIdentifier: "EmailUsername") as! UINavigationController
            //var vc = nc.viewControllers.first as! EmailUsernameViewController
            var vc = storyboard.instantiateViewController(withIdentifier: "EmailUsername") as! EmailUsernameViewController
            vc.bindViewModel(to: viewModel)
            return vc
        case .name(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "Name") as! UINavigationController
            var vc = nc.viewControllers.first as! NameViewController
            vc.bindViewModel(to: viewModel)
            return nc
        case .passwords(let viewModel):
            //let nc = storyboard.instantiateViewController(withIdentifier: "Passwords") as! UINavigationController
            //var vc = nc.viewControllers.first as! PasswordsViewController
            var vc = storyboard.instantiateViewController(withIdentifier: "Passwords") as! PasswordsViewController
            vc.bindViewModel(to: viewModel)
            return vc
        }
    }
}

extension LoginScene {
    fileprivate func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        switch self {
        case .login(let viewModel):
            var vc = storyboard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
            vc.bindViewModel(to: viewModel)
            return vc
        }
    }
}
