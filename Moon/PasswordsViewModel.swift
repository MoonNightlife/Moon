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
    var newUser: NewUser!
    let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    var passwordText = BehaviorSubject<String>(value: "")
    var retypePasswordText = BehaviorSubject<String>(value: "")
    
    // Outputs
    var passwordsMatch: Observable<Bool> {
        return Observable.combineLatest(passwordText, retypePasswordText).map(==)
    }
    var acceptablePassword: Observable<Bool> {
        return passwordText.map(ValidationUtility.validPassword)
    }
    var doneButtonActive: Observable<Bool> {
        return Observable.combineLatest(passwordsMatch, acceptablePassword).map { $0 && $1 }
    }
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
    }
    
    func onCreateUser() -> CocoaAction {
        return CocoaAction {_ in
            print("Create User")
            return .just()
        }
    }

}
