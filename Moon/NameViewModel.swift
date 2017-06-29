//
//  NameViewModel.swift
//  Moon
//
//  Created by Evan Noble on 5/31/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action
import RxCocoa

struct NameViewModel {
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    private let newUser: NewUser
    
    // Private
    private let disposeBag = DisposeBag()
    
    // Inputs
    var firstName = BehaviorSubject<String?>(value: nil)
    var lastName = BehaviorSubject<String?>(value: nil)
    
    // Outputs
    var dataValid: Driver<Bool>
    
    init(coordinator: SceneCoordinatorType, user: NewUser) {
        self.sceneCoordinator = coordinator
        self.newUser = user
        
        dataValid = Observable.combineLatest(firstName, lastName).map(ValidationUtility.validName).asDriver(onErrorJustReturn: false)
        
        subscribeToInputs()
    }
    
    private func subscribeToInputs() {
        firstName
            .subscribe(onNext: {
                self.newUser.firstName = $0?.trimmed
            })
            .addDisposableTo(disposeBag)
        
        lastName
            .subscribe(onNext: {
                self.newUser.lastName = $0?.trimmed
            })
            .addDisposableTo(disposeBag)
    }

    func nextSignUpScreen() -> CocoaAction {
        return CocoaAction(workFactory: {
            let viewModel = BirthdaySexViewModel(coordinator: self.sceneCoordinator, user: self.newUser)
            return self.sceneCoordinator.transition(to: Scene.SignUp.birthdaySex(viewModel), type: .push)
        })
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction {
            self.sceneCoordinator.pop()
        }
    }
}
