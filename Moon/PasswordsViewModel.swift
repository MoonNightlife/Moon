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
import FirebaseAuth

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
    
    func createUser() -> CocoaAction {
        return CocoaAction(enabledIf: self.allValid, workFactory: {_ in
            return Observable.create({ (observer) -> Disposable in
                if let email = self.newUser.email, let password = self.newUser.password {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if user != nil {
                            observer.onNext()
                        } else if let e = error {
                            observer.onError(e)
                        } else {
                            observer.onError(MyError.SignUpError)
                        }
                    })
                } else {
                    observer.onError(MyError.SignUpError)
                }
                return Disposables.create()
            }).flatMap({
                return self.loginAction().execute()
            })
        })
    }
    
    func loginAction() -> CocoaAction {
        return CocoaAction(workFactory: { _ in
            let mainVM = MainViewModel(coordinator: self.sceneCoordinator)
            let searchVM = SearchBarViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.Master.searchBarWithMain(searchBar: searchVM, mainView: mainVM), type: .root)
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
    
    func onBack() -> CocoaAction {
        return CocoaAction {
            self.sceneCoordinator.pop()
        }
    }
}
