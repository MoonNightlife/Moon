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
    let sceneCoordinator: SceneCoordinatorType
    
    // Private
    private let disposeBag = DisposeBag()
    
    // Inputs
    var firstName = BehaviorSubject<String?>(value: nil)
    var lastName = BehaviorSubject<String?>(value: nil)
    
    // Ouputs
    var dataValid: Observable<Bool> {
        return Observable.combineLatest(firstName, lastName)
            .map(ValidationUtility.validName)
    }
    
    // Dependencies
    
    var newUser: NewUser!
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
    }

    func nextSignUpScreen() -> CocoaAction {
        return CocoaAction {
            let viewModel = BirthdaySexViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: .birthdaySex(viewModel), type: .push)
        }
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction {
            self.sceneCoordinator.pop(animated: true)
        }
    }
}
