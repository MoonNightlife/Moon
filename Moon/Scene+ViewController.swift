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
        case .edit(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "EditProfileNavigation") as! UINavigationController
            var vc = nc.viewControllers.first as! EditProfileViewController
            vc.bindViewModel(to: viewModel)
            return nc
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
        case .notification(let viewModel):
            var vc = storyboard.instantiateViewController(withIdentifier: "NotificationSettings") as! NotificationSettingsViewController
            vc.bindViewModel(to: viewModel)
            return vc
        case .webView(let viewModel):
            var vc = storyboard.instantiateViewController(withIdentifier: "WebView") as! WebViewUIViViewController
            vc.bindViewModel(to: viewModel)
            return vc
        case .region(let viewModel):
            var vc = storyboard.instantiateViewController(withIdentifier: "SelectRegion") as! SelectRegionViewController
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
        case .tutorial(let viewModel):
            var vc = storyBoard.instantiateViewController(withIdentifier: "Tutorial") as! TutorialViewController
            vc.bindViewModel(to: viewModel)
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
            let nc = storyBoard.instantiateViewController(withIdentifier: "EnterPhoneNumberNavigationController") as! UINavigationController
            var vc = nc.viewControllers.first as! EnterPhoneNumberViewController
            vc.bindViewModel(to: viewModel)
            return nc
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
            let nc = storyBoard.instantiateViewController(withIdentifier: "ContactNavigationController") as! UINavigationController
            var vc = nc.viewControllers.first as! ContactsViewController
            vc.bindViewModel(to: viewModel)
            
            return nc
        }
    }
}

extension Scene.Group {
    func viewController() -> UIViewController {
        let storyBoard = UIStoryboard(name: "Group", bundle: nil)
        let userStoryboard = UIStoryboard(name: "User", bundle: nil)
        switch self {
        case .relationship(let viewModel, let friendsVM, let groupVM):
            
            let ncFriends = userStoryboard.instantiateViewController(withIdentifier: "UsersTableNavigation") as! UINavigationController
            var vcFriends = ncFriends.viewControllers.first as! UsersTableViewController
            
            let ncGroups = storyBoard.instantiateViewController(withIdentifier: "ViewGroupNavigation") as! UINavigationController
            var vcGroups = ncGroups.viewControllers.first as! ViewGroupsViewController
     
            let nc = storyBoard.instantiateViewController(withIdentifier: "RelationNavigation") as! UINavigationController
            var vc = nc.viewControllers.first as! RelationshipViewController
     
            vc.bindViewModel(to: viewModel)
            vcFriends.bindViewModel(to: friendsVM)
            vcGroups.bindViewModel(to: groupVM)
            
            vc.generateChildern(child1: vcFriends, child2: vcGroups)
            
            return nc
            
        case .createGroup(let viewModel):
            let nc = storyBoard.instantiateViewController(withIdentifier: "CreateEditGroupNavigation") as! UINavigationController
            var vc = nc.viewControllers.first as! CreateEditGroupViewController
            vc.bindViewModel(to: viewModel)
            return nc
        case .editGroup(let viewModel):
            var vc = storyBoard.instantiateViewController(withIdentifier: "CreateEditGroup") as! CreateEditGroupViewController
            vc.bindViewModel(to: viewModel)
            return vc
        case .groupActivity(let viewModel):
            let nc = storyBoard.instantiateViewController(withIdentifier: "GroupActivityNavigation") as! UINavigationController
            var vc = nc.viewControllers.first as! GroupActivityViewController
            vc.bindViewModel(to: viewModel)
            return nc
        case .manageGroup(let viewModel):
            let nc = storyBoard.instantiateViewController(withIdentifier: "ManageGroupNavigation") as! UINavigationController
            var vc = nc.viewControllers.first as! ManageGroupViewController
            vc.bindViewModel(to: viewModel)
            return nc
        case .viewGroups(let viewModel):
            var vc = storyBoard.instantiateViewController(withIdentifier: "ViewGroups") as! ViewGroupsViewController
            vc.bindViewModel(to: viewModel)
            return vc
        }
    }
}
