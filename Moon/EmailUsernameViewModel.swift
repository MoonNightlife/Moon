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
    private let newUser: NewUser
    private let sceneCoordinator: SceneCoordinatorType
    private let disposeBag = DisposeBag()
    
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
    
    init(coordinator: SceneCoordinatorType, user: NewUser) {
        self.sceneCoordinator = coordinator
        self.newUser = user
        subscribeToInputs()
    }
    
    private func subscribeToInputs() {
        username
            .subscribe(onNext: {
                self.newUser.username = $0
            })
            .addDisposableTo(disposeBag)
        
        email
            .subscribe(onNext: {
                self.newUser.email = $0
            })
            .addDisposableTo(disposeBag)
    }
    
    func nextSignUpScreen() -> CocoaAction {
        return CocoaAction {
            let viewModel = PasswordsViewModel(coordinator: self.sceneCoordinator, user: self.newUser)
            return self.sceneCoordinator.transition(to: Scene.SignUpScene.passwords(viewModel), type: .push)
        }
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction {
            self.sceneCoordinator.pop()
        }
    }
}
