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

struct BirthdaySexViewModel {
    
    let sexPickerViewOptions = ["", "Male", "Female", "Rather Not Say"]
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    private let newUser: NewUser
    
    // Private
    private var validInfo: Observable<Bool> {
        let validBirthday = birthdayString
            .map {
                self.dateFormatter.date(from: $0)
            }
            .map(ValidationUtility.validBirthday)
        let validSex = sexString.map({ $0 != "" })
        return Observable.combineLatest(validBirthday, validSex).map({ $0 && $1 })
    }
    private let disposeBag = DisposeBag()
    private var dateFormatter: DateFormatter! {
        let df = DateFormatter()
        df.dateStyle = .short
        return df
    }
    
    // Inputs
    var birthday = BehaviorSubject<Date>(value: Date())
    var sexPicker = BehaviorSubject<(Int, Int)>(value: (0, 0))
    
    // Outputs
    var birthdayString: Observable<String>!
    var sexString: Observable<String>!
    
    init(coordinator: SceneCoordinatorType, user: NewUser) {
        self.sceneCoordinator = coordinator
        self.newUser = user
        
        birthdayString = birthday.skip(1).map(dateFormatter.string)
            .do(onNext: {
                user.birthday = $0
            })
            .startWith(user.birthday)
            .filterNil()
        
        let sex = sexPicker.skip(1)
            .map({
                return Sex(rawValue: $0.0 - 1) ?? Sex.none
            })
            .startWith(user.sex)
            .filterNil()
        
        sexString = sex
            .do(onNext: {
                user.sex = $0
            })
            .map({
                $0.toString()
            })
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
