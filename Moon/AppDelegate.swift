//
//  AppDelegate.swift
//  Moon
//
//  Created by Evan Noble on 4/16/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    enum LaunchScreen {
        case login
        case barProfile
        case main
    }

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = .lightContent
        
        if let url = launchOptions?[.url] as? URL {
            return executeDeepLink(with: url)
        } else {
            //TODO: check if user is logged in
            prepareEntryViewController(vc: .login)
            return true
        }
    }
    
    func application(_: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return url.scheme == "moonnightlife" && executeDeepLink(with: url)
    }
    
    fileprivate func prepareEntryViewController(vc: LaunchScreen) {
        let sceneCoordinator = SceneCoordinator(window: window!)
        
        switch vc {
        case .login:
            let viewModel = LoginViewModel(coordinator: sceneCoordinator)
            let firstScene = Scene.Login.login(viewModel)
            sceneCoordinator.transition(to: firstScene, type: .root)
        case .main:
            let mainVM = MainViewModel(coordinator: sceneCoordinator)
            let searchVM = SearchBarViewModel(coordinator: sceneCoordinator)
            sceneCoordinator.transition(to: Scene.Master.searchBarWithMain(searchBar: searchVM, mainView: mainVM), type: .root)
        case .barProfile:
            let mainVM = MainViewModel(coordinator: sceneCoordinator)
            let searchVM = SearchBarViewModel(coordinator: sceneCoordinator)
            sceneCoordinator.transition(to: Scene.Master.searchBarWithMain(searchBar: searchVM, mainView: mainVM), type: .root)
            let barVM = BarProfileViewModel(coordinator: sceneCoordinator)
            sceneCoordinator.transition(to: Scene.Bar.profile(barVM), type: .modal)
        }
    }
    
}

// MARK: - Deep Link
extension AppDelegate {
    fileprivate func executeDeepLink(with url: URL) -> Bool {
        // Create a recognizer with this app's custom deep link types.
        let recognizer = DeepLinkRecognizer(deepLinkTypes: [ShowEventDeepLink.self])
        
        // Try to create a deep link object based on the URL.
        guard let deepLink = recognizer.deepLink(matching: url) else {
            print("Unable to match URL: \(url.absoluteString)")
            return false
        }
        
        // Navigate to the view or content specified by the deep link.
        switch deepLink {
        case let link as ShowEventDeepLink: return showEvent(with: link)
        default: fatalError("Unsupported DeepLink: \(type(of: deepLink))")
        }
    }
    
    fileprivate func showEvent(with deepLink: ShowEventDeepLink) -> Bool {
        //TODO: Present bar profile for bar id in deep link if logged in
        prepareEntryViewController(vc: .barProfile)
        print("Show Event")
        return true
    }
}
