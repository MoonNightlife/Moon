//
//  PasswordsViewModel.swift
//  Moon
//
//  Created by Evan Noble on 5/31/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action

struct PasswordsViewModel {
    
    // Dependencies
    private let newUser: NewUser
    private let sceneCoordinator: SceneCoordinatorType
    private let disposeBag = DisposeBag()
    
    // Inputs
    var passwordText = BehaviorSubject<String>(value: "")
    var retypePasswordText = BehaviorSubject<String>(value: "")
    
    // Outputs
    var showPasswordsMatchError: Observable<Bool> {
        let passwordsMatch = Observable.combineLatest(passwordText, retypePasswordText).map(==)
        return Observable.combineLatest(passwordsMatch, retypePasswordText).map({
            return !$0 && $1 != ""
        })
    }
    var showAcceptablePasswordError: Observable<Bool> {
        let validPassword = passwordText.map(ValidationUtility.validPassword)
        return Observable.combineLatest(validPassword, passwordText).map({
            return !$0 && $1 != ""
        })
    }
    var allValid: Observable<Bool> {
        return Observable.combineLatest(passwordText, retypePasswordText)
            .map({ (password1, password2) in
                return ValidationUtility.validPassword(password: password1) && password1 == password2
            })
    }
    
    init(coordinator: SceneCoordinatorType, user: NewUser) {
        self.sceneCoordinator = coordinator
        self.newUser = user
        subscribeToInputs()
    }
    
    private func subscribeToInputs() {
        passwordText
            .subscribe(onNext: {
                self.newUser.password = $0
            })
            .addDisposableTo(disposeBag)
    }
    
    func onCreateUser() -> CocoaAction {
        return CocoaAction(enabledIf: allValid, workFactory: {
            print("Create User")
            self.newUser.listPropertiesWithValues()
            return .just()

        })
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction {
            self.sceneCoordinator.pop()
        }
    }

}
