//
//  SettingsViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/8/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Action
import RxSwift
import RxDataSources
import FirebaseAuth

struct SettingsViewModel: AuthNetworkingInjected {
    
    // Outputs
    lazy var showNextScreen: Action<Setting, Void> = { this in
        return Action(workFactory: {
            guard let scene = this.getSceneFor(section: $0) else {
                return Observable.empty()
            }
            if case Scene.Login.login(_) = scene {
                return this.authAPI.signOut().flatMap({
                    return this.sceneCoordinator.transition(to: scene, type: .root)
                })
            } else {
                return this.sceneCoordinator.transition(to: scene, type: .push)
            }
        })
    }(self)
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
     
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction {
            return self.sceneCoordinator.pop()
        }
    }

    fileprivate func getSceneFor(section: Setting) -> SceneType? {
        switch section {
        case .accountActions(let option):
            return getSceneFor(accountAction: option)
        case .moreInformation(let option):
            return getSceneFor(moreInformation: option)
        case .myAccount(let option):
            return getSceneFor(myAccount: option)
        }
    }
    
    fileprivate func getSceneFor(accountAction: SettingSections.AccountActions) -> SceneType? {
        switch accountAction {
        case .deleteAccount:
            let vm = DeleteAccountViewModel(coordinator: self.sceneCoordinator)
            return Scene.User.deleteAccount(vm)
        case .logOut:
            let vm = LoginViewModel(coordinator: self.sceneCoordinator)
            return Scene.Login.login(vm)
        }
    }
    
    fileprivate func getSceneFor(myAccount: SettingSections.MyAccount) -> SceneType? {
        switch myAccount {
        case .changeEmail:
            let vm = EmailSettingsViewModel(coordinator: self.sceneCoordinator)
            return Scene.User.email(vm)
        case .changeName:
            let vm = NameSettingsViewModel(coordinator: self.sceneCoordinator)
            return Scene.User.name(vm)
        case .changePhoneNumber:
            let vm = EnterPhoneNumberViewModel(coordinator: self.sceneCoordinator)
            return Scene.UserDiscovery.enterPhoneNumber(vm)
        case .notifications:
            let vm = NotificationSettingsViewModel(coordinator: self.sceneCoordinator)
            return Scene.User.notification(vm)
        }
    }
    
    fileprivate func getSceneFor(moreInformation: SettingSections.MoreInformation) -> SceneType? {
        switch moreInformation {
        case .privacyPolicy:
            let vm = WebViewViewModel(coordinator: self.sceneCoordinator, url: URL(string: "http://apple.com")!)
            return Scene.User.webView(vm)
        case .support:
            let vm = WebViewViewModel(coordinator: self.sceneCoordinator, url: URL(string: "https://www.google.com")!)
            return Scene.User.webView(vm)
        case .termsAndConditions:
            let vm = WebViewViewModel(coordinator: self.sceneCoordinator, url: URL(string: "http://www.yahoo.com")!)
            return Scene.User.webView(vm)
        }
    }

}
