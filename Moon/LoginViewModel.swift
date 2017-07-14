//
//  LoginViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/2/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action
import FirebaseAuth

struct LoginViewModel: AuthNetworkingInjected, FacebookNetworkingInjected {
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    var email = Variable<String?>(nil)
    var password = Variable<String?>(nil)
    
    // Ouputs
    var showLoadingIndicator = Variable(false)
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
        
    }
    
    func onSignUp() -> CocoaAction {
        return CocoaAction {
            return self.signUpAction(facebookProfile: nil)
        }
    }
    
    func onForgotPassword() -> CocoaAction {
        return CocoaAction {
            let viewModel = ForgotPasswordViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.Login.forgotPassword(viewModel), type: .push)
        }
    }
    
    func onSignIn() -> CocoaAction {
        return CocoaAction {_ in
            if let email = self.email.value, let password = self.password.value {
                return self.authAPI.login(credentials: .email(credentials: EmailCredentials(email: email, password: password)))
                    .flatMap({_ in 
                        return self.loginAction()
                    })

            } else {
                return Observable.empty()
            }
        }
    }
    
    func onFacebookSignIn() -> CocoaAction {
        return CocoaAction { _ in
            if self.facebookAPI.isUserAlreadyLoggedIn() {
                return self.continueLogin().do(onSubscribed: { 
                    self.showLoadingIndicator.value = true
                }, onDispose: {
                    self.showLoadingIndicator.value = false
                })
            } else {
                return self.facebookAPI.login().flatMap({
                    return self.continueLogin().do(onSubscribed: {
                        self.showLoadingIndicator.value = true
                    }, onDispose: {
                        self.showLoadingIndicator.value = false
                    })
                })
            }
        }
    }
    
    func continueLogin() -> Observable<Void> {
        return self.authAPI.login(credentials: self.facebookAPI.getProviderCredentials())
            .flatMap({
                return self.authAPI.checkForFirstTimeLogin(userId: $0)
            }).flatMap({ isFirstTime -> Observable<Void> in
                if isFirstTime {
                    return self.facebookAPI.getBasicProfileForSignedInUser().flatMap({
                        self.signUpAction(facebookProfile: $0)
                    })
                } else {
                    return self.loginAction()
                }
            })
    }
    
    func signUpAction(facebookProfile: FacebookUserInfo?) -> Observable<Void> {
        
        var newUser: NewUser!
        if let profile = facebookProfile {
             newUser = NewUser(facebookInfo: profile)
        } else {
            newUser = NewUser()
        }
        
        let viewModel = NameViewModel(coordinator: self.sceneCoordinator, user: newUser)
        return self.sceneCoordinator.transition(to: Scene.SignUp.name(viewModel), type: .push)
    }
    
    func loginAction() -> Observable<Void> {
        let mainVM = MainViewModel(coordinator: self.sceneCoordinator)
        let searchVM = SearchBarViewModel(coordinator: self.sceneCoordinator)
        return self.sceneCoordinator.transition(to: Scene.Master.searchBarWithMain(searchBar: searchVM, mainView: mainVM), type: .root)
    }

}
