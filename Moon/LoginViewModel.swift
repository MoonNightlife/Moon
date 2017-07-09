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

struct LoginViewModel: AuthNetworkingInjected {
    
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
            let newUser = NewUser()
            let viewModel = NameViewModel(coordinator: self.sceneCoordinator, user: newUser)
            return self.sceneCoordinator.transition(to: Scene.SignUp.name(viewModel), type: .push)
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
                return self.authAPI.login(credentials: .email(email: email, password: password))
                    .flatMap({_ in 
                        return self.loginAction()
                    })

            } else {
                return Observable.empty()
            }
        }
    }
    
    func loginAction() -> Observable<Void> {
        let mainVM = MainViewModel(coordinator: self.sceneCoordinator)
        let searchVM = SearchBarViewModel(coordinator: self.sceneCoordinator)
        return self.sceneCoordinator.transition(to: Scene.Master.searchBarWithMain(searchBar: searchVM, mainView: mainVM), type: .root)
    }

}
