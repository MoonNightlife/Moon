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
    var username = BehaviorSubject<String?>(value: nil)
    var email = BehaviorSubject<String?>(value: nil)
    
    // Outputs
    var showEmailError: Observable<Bool> {
        let validEmail = email.map(ValidationUtility.validEmail)
        return Observable.combineLatest(email, validEmail)
            .map({ (email, validEmail) in
                guard let e = email else {
                    return false
                }
                
                // return true if string is not blank and email is not valid
                return (e != "") && !validEmail
            })
    }
    
    var showUsernameError: Observable<Bool> {
        let validUsername = username.map(ValidationUtility.validUsername)
        return Observable.combineLatest(username, validUsername)
            .map({ (username, validUsername) in
                guard let un = username else {
                    return false
                }
                
                // return true if string is not blank and email is not valid
                return (un != "") && !validUsername
            })
    }
    
    var allFieldsValid: Observable<Bool> {
        return Observable.combineLatest(username.map(ValidationUtility.validUsername), email.map(ValidationUtility.validEmail)).map({$0 && $1})
    }
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
    }
    
    func nextSignUpScreen() -> CocoaAction {
        return CocoaAction {
            let viewModel = PasswordsViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.signUp(.passwords(viewModel)), type: .push)
        }
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction {
            self.sceneCoordinator.pop()
        }
    }
}
