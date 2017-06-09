//
//  BirthdaySexViewModel.swift
//  Moon
//
//  Created by Evan Noble on 5/31/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action
import SwaggerClient

struct BirthdaySexViewModel {
    
    let sexPickerViewOptions = ["", "Male", "Female", "Rather Not Say"]
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    private let newUser: RegistrationProfile
    
    // Private
    private let validInfo: Observable<Bool>
    private let disposeBag = DisposeBag()
    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .short
        return df
    }
    
    // Inputs
    var birthday = BehaviorSubject<Date>(value: Date())
    var sex = BehaviorSubject<(Int, Int)>(value: (0, 0))
    
    // Outputs
    var birthdayString: Observable<String>!
    var sexString: Observable<String>!
    
    init(coordinator: SceneCoordinatorType, user: RegistrationProfile) {
        self.sceneCoordinator = coordinator
        self.newUser = user
        
        let validBirthday = birthday.map(ValidationUtility.validBirthday)
        let validSex = sex.map({ $0.0 != 0 })
        validInfo = Observable.combineLatest(validBirthday, validSex).map({ $0 && $1 })
        
        birthdayString = birthday.skip(1).map(dateFormatter.string)
        sexString = sex.map({
            switch $0.0 {
            case 0: return ""
            case 1: return "Male"
            case 2: return "Female"
            case 3: return "Other"
            default: return ""
            }
        })
        
        subscribeToInputs()
    }
    
    fileprivate func subscribeToInputs() {
        birthdayString
            .subscribe(onNext: {
                self.newUser.birthday = $0
            })
            .addDisposableTo(disposeBag)
        
        sexString
            .subscribe(onNext: {
                self.newUser.sex = $0
            })
            .addDisposableTo(disposeBag)
    }
    
    func nextSignUpScreen() -> CocoaAction {
        return CocoaAction(enabledIf: validInfo, workFactory: {
            let viewModel = EmailUsernameViewModel(coordinator: self.sceneCoordinator, user: self.newUser)
            return self.sceneCoordinator.transition(to: Scene.SignUp.emailUsername(viewModel), type: .push)
        })
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction {
            self.sceneCoordinator.pop()
        }
    }
    
}
