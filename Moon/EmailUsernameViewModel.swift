//
//  EmailUsernameViewModel.swift
//  Moon
//
//  Created by Evan Noble on 5/31/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action

struct EmailUsernameViewModel {
    
    // Dependencies
    var newUser: NewUser!
    let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    var username = BehaviorSubject<String>(value: "")
    var email = BehaviorSubject<String>(value: "")
    
    // Outputs
    var emailValid: Observable<Bool> {
        return email
            .map(ValidationUtility.validEmail)
    }
    
    var usernameValid: Observable<Bool> {
        return username
            .map(ValidationUtility.validUsername)
    }
    var allFieldsValid: Observable<Bool> {
        return Observable.combineLatest(usernameValid, emailValid)
            .map { $0 && $1 }
    }
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
    }
    
    func nextSignUpScreen() -> CocoaAction {
        return CocoaAction {
            let viewModel = PasswordsViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: SignUpScene.passwords(viewModel), type: .push)
        }
    }
}
