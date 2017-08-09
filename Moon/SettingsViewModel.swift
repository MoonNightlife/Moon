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
import RxCocoa
import RxDataSources
import FirebaseAuth
import FirebaseMessaging

struct SettingsViewModel: AuthNetworkingInjected, NetworkingInjected {
    
    // Action
    lazy var showNextScreen: Action<Setting, Void> = { this in
        return Action(workFactory: {
            guard let scene = this.getSceneFor(section: $0) else {
                return Observable.empty()
            }
            if case Scene.Login.login(_) = scene {
                this.loadingIndicator.value = true
                if let token = Messaging.messaging().fcmToken {
                    return this.authAPI.removeFCMToken(token: token).flatMap({
                        return this.authAPI.signOut().do(onNext: {
                            this.loadingIndicator.value = false
                        })
                    })
                } else {
                    return this.authAPI.signOut().do(onNext: {
                        this.loadingIndicator.value = false
                    })

                }
        
            } else if case Scene.UserDiscovery.enterPhoneNumber(_) = scene {
                return this.sceneCoordinator.transition(to: scene, type: .modal)
            } else {
                return this.sceneCoordinator.transition(to: scene, type: .push)
            }
        })
    }(self)
    
    lazy var loadUserInfo: Action<Void, UserProfile> = { this in
        return Action {
            return this.userAPI.getUserProfile(userID: this.authAPI.SignedInUserID)
        }
    }(self)
    
    lazy var updatePrivacy: Action<Bool, Void> = { this in
        return Action {
            return this.userAPI.updatePrivacySetting(userID: this.authAPI.SignedInUserID, privacy: $0)
        }
    }(self)
    
    // Output
    var email: Observable<String>!
    var phoneNumber: Observable<String>!
    var username: Observable<String>!
    var loadingIndicator = Variable<Bool>(false)
    var privacy: Driver<Bool> {
        return self.userAPI.getPrivacySetting(userID: self.authAPI.SignedInUserID).startWith(false).asDriver(onErrorJustReturn: false)
    }
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
        
        let user = loadUserInfo.elements
        phoneNumber = user.map { $0.phoneNumber ?? ""}
        username = user.map({
            $0.username ?? ""
        })
        email = user.map { $0.email ?? ""}
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
        case .username:
            return nil
        case .changeEmail:
            let vm = EmailSettingsViewModel(coordinator: self.sceneCoordinator)
            return Scene.User.email(vm)
        case .changePhoneNumber:
            let vm = EnterPhoneNumberViewModel(coordinator: self.sceneCoordinator, partOfSignupFlow: false)
            return Scene.UserDiscovery.enterPhoneNumber(vm)
        case .notifications:
            let vm = NotificationSettingsViewModel(coordinator: self.sceneCoordinator)
            return Scene.User.notification(vm)
        }
    }
    
    fileprivate func getSceneFor(moreInformation: SettingSections.MoreInformation) -> SceneType? {
        switch moreInformation {
        case .privacyPolicy:
            let vm = WebViewViewModel(coordinator: self.sceneCoordinator, url: URL(string: "https://www.iubenda.com/privacy-policy/7891983")!)
            return Scene.User.webView(vm)
        case .support:
            let vm = WebViewViewModel(coordinator: self.sceneCoordinator, url: URL(string: "http://www.moonnightlifeapp.com/home")!)
            return Scene.User.webView(vm)
        case .termsAndConditions:
            let vm = WebViewViewModel(coordinator: self.sceneCoordinator, url: URL(string: "https://www.iubenda.com/privacy-policy/7891983")!)
            return Scene.User.webView(vm)
        }
    }

}
