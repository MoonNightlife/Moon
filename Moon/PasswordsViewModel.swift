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
import SwaggerClient

struct PasswordsViewModel {
    
    // Dependencies
    private let newUser: RegistrationProfile
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
    
    lazy var createUser: CocoaAction = { this in
        return CocoaAction(enabledIf: this.allValid, workFactory: {_ in
            return UserAPI.createNewUser(user: this.newUser)
        })
    }(self)
    
    lazy var loginAction: CocoaAction = { this in
        return CocoaAction(workFactory: { _ in
            let mainVM = MainViewModel(coordinator: this.sceneCoordinator)
            let searchVM = SearchBarViewModel(coordinator: this.sceneCoordinator)
            return this.sceneCoordinator.transition(to: Scene.Master.searchWithMain(searchBar: searchVM, mainView: mainVM), type: .root)
        })
    }(self)
    
    init(coordinator: SceneCoordinatorType, user: RegistrationProfile) {
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
    
    func onBack() -> CocoaAction {
        return CocoaAction {
            self.sceneCoordinator.pop()
        }
    }
}
