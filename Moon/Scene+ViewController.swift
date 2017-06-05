//
//  Scene+ViewController.swift
//  Moon
//
//  Created by Evan Noble on 6/1/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit

protocol SceneType {
    func viewController() -> UIViewController
}

//swiftlint:disable force_cast
extension Scene.SignUp {
    internal func viewController() -> UIViewController {
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
            var vc = storyboard.instantiateViewController(withIdentifier: "Name") as! NameViewController
            vc.bindViewModel(to: viewModel)
            return vc
        case .passwords(let viewModel):
            var vc = storyboard.instantiateViewController(withIdentifier: "Passwords") as! PasswordsViewController
            vc.bindViewModel(to: viewModel)
            return vc
        }
    }
}

extension Scene.Login {
    internal func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        switch self {
        case .login(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "Login") as! UINavigationController
            var vc = nc.viewControllers.first as! LoginViewController
            vc.bindViewModel(to: viewModel)
            return nc
        case .forgotPassword(let viewModel):
            var vc = storyboard.instantiateViewController(withIdentifier: "ForgotPassword") as! ForgotPasswordViewController
            vc.bindViewModel(to: viewModel)
            return vc
        }
    }
}

extension Scene.User {
    internal func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        switch self {
        case .profile(let viewModel):
            var vc = storyboard .instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
            vc.bindViewModel(to: viewModel)
            return vc
        }
    }
}

extension Scene.Master {
    internal func viewController() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Master", bundle: nil)
        switch self {
        case .main((let searchBarVM, let mainVM)):
            var vc = storyBoard.instantiateViewController(withIdentifier: "Main") as! MainViewController
            vc.bindViewModel(to: mainVM)
            var searchController = SearchBarViewController(rootViewController: vc)
            searchController.bindViewModel(to: searchBarVM)
            return searchController
        }
    }
}
