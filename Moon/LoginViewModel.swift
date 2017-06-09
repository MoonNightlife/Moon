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
import SwaggerClient

struct LoginViewModel {
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    var email = BehaviorSubject<String?>(value: nil)
    var password = BehaviorSubject<String?>(value: nil)
    
    // Ouputs
    var showLoadingIndicator = Variable(false)
    
    init(coordinator: SceneCoordinator) {
        self.sceneCoordinator = coordinator
        
    }
    
    func onSignUp() -> CocoaAction {
        return CocoaAction {
            let newUser = RegistrationProfile()
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
        return CocoaAction {
            let mainVM = MainViewModel(coordinator: self.sceneCoordinator)
            let searchVM = SearchBarViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.Master.main(searchBar: searchVM, mainView: mainVM), type: .root)
        }
    }

}
