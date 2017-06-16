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
            var vc = storyboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
            vc.bindViewModel(to: viewModel)
            return vc
        case .usersTable(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "UsersTableNavigation") as! UINavigationController
            var vc = nc.viewControllers.first as! UsersTableViewController
            vc.bindViewModel(to: viewModel)
            return nc
        case .settings(let viewModel):
            var vc = storyboard.instantiateViewController(withIdentifier: "Settings") as! SettingsViewController
            vc.bindViewModel(to: viewModel)
            return vc
        case .deleteAccount(let viewModel):
            var vc = storyboard.instantiateViewController(withIdentifier: "DeleteAccount") as! DeleteAccountViewController
            vc.bindViewModel(to: viewModel)
            return vc
        case .email(let viewModel):
            var vc = storyboard.instantiateViewController(withIdentifier: "EmailSettings") as! EmailSettingsViewController
            vc.bindViewModel(to: viewModel)
            return vc
        case .name(let viewModel):
            var vc = storyboard.instantiateViewController(withIdentifier: "NameSettings") as! NameSettingsViewController
            vc.bindViewModel(to: viewModel)
            return vc
        case .notification(let viewModel):
            var vc = storyboard.instantiateViewController(withIdentifier: "NotificationSettings") as! NotificationSettingsViewController
            vc.bindViewModel(to: viewModel)
            return vc
        case .webView(let viewModel):
            var vc = storyboard.instantiateViewController(withIdentifier: "WebView") as! WebViewUIViViewController
            vc.bindViewModel(to: viewModel)
            return vc
        }
    }
}

extension Scene.Master {
    internal func viewController() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Master", bundle: nil)
        switch self {
        case .searchBarWithMain((let searchBarVM, let mainVM)):
            var vc = storyBoard.instantiateViewController(withIdentifier: "Main") as! MainViewController
            vc.bindViewModel(to: mainVM)
            var searchController = SearchBarViewController(rootViewController: vc)
            searchController.bindViewModel(to: searchBarVM)
            let nc = UINavigationController(rootViewController: searchController)
            return nc
        case .main(let viewModel):
            var vc = storyBoard.instantiateViewController(withIdentifier: "Main") as! MainViewController
            vc.bindViewModel(to: viewModel)
            return vc
        case .search(let searchVM, let searchResultVM, let contentSuggestionVM):
            var vc = storyBoard.instantiateViewController(withIdentifier: "Search") as! SearchViewController
            var vcSC = storyBoard.instantiateViewController(withIdentifier: "ContentSuggestions") as! ContentSuggestionsViewController
            var vcSR = storyBoard.instantiateViewController(withIdentifier: "SearchResults") as! SearchResultsViewController
            vc.bindViewModel(to: searchVM)
            vcSR.bindViewModel(to: searchResultVM)
            vcSC.bindViewModel(to: contentSuggestionVM)
            vc.generateChildern(child1: vcSC, child2: vcSR)
        
            return vc
        }

    }
}

extension Scene.Featured {
    func viewController() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Featured", bundle: nil)
        switch self {
        case .featured(let viewModel):
            var vc = storyBoard.instantiateViewController(withIdentifier: "Featured") as! FeaturedViewController
            vc.bindViewModel(to: viewModel)
            return vc
        }
    }
}

extension Scene.Explore {
    func viewController() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Featured", bundle: nil)
        switch self {
        case .explore(let viewModel):
            var vc = storyBoard.instantiateViewController(withIdentifier: "Explore") as! ExploreViewController
            vc.bindViewModel(to: viewModel)
            return vc
        }
    }
}

extension Scene.MoonsView {
    func viewController() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Featured", bundle: nil)
        switch self {
        case .moonsView(let viewModel):
            var vc = storyBoard.instantiateViewController(withIdentifier: "MoonsView") as! MoonsViewViewController
            vc.bindViewModel(to: viewModel)
            return vc
        }
    }
}

extension Scene.Bar {
    func viewController() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Bar", bundle: nil)
        switch self {
        case .profile(let viewModel):
            let nc = storyBoard.instantiateViewController(withIdentifier: "BarProfileNavigationController") as! UINavigationController
            var vc = nc.viewControllers.first as! BarProfileViewController
            vc.bindViewModel(to: viewModel)
            return nc
        case .info(let viewModel):
            var vc = storyBoard.instantiateViewController(withIdentifier: "BarInfo") as! BarInfoViewController
            vc.bindViewModel(to: viewModel)
            return vc
        }
    }
}

extension Scene.UserDiscovery {
    func viewController() -> UIViewController {
        let storyBoard = UIStoryboard(name: "UserDiscovery", bundle: nil)
        switch self {
        case .enterPhoneNumber(let viewModel):
            var vc = storyBoard.instantiateViewController(withIdentifier: "EnterPhoneNumber") as! EnterPhoneNumberViewController
            vc.bindViewModel(to: viewModel)
            return vc
        case .enterCode(let viewModel):
            var vc = storyBoard.instantiateViewController(withIdentifier: "EnterCode") as! EnterCodeViewController
            vc.bindViewModel(to: viewModel)
            return vc
        case .countryCode(let viewModel):
            let nc = storyBoard.instantiateViewController(withIdentifier: "CountryCodeNavigation") as! UINavigationController
            var vc = nc.viewControllers.first as! CountryCodeViewController
            vc.bindViewModel(to: viewModel)
            return nc
        case .contacts(let viewModel):
            var vc = storyBoard.instantiateViewController(withIdentifier: "Contacts") as! ContactsViewController
            vc.bindViewModel(to: viewModel)
            return vc
        }
    }
}
