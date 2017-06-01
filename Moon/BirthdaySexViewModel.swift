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
    
    let sexPickerViewOptions = ["Male", "Female", "Rather Not Say"]
    
    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    
    var newUser: NewUser!
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .short
        return df
    }
    
    // Inputs
    var birthday = BehaviorSubject<Date>(value: Date())
    var sex = BehaviorSubject<(Int, Int)>(value: (0, 0))
    
    // Outputs
    var birthdayString: Observable<String> {
        return birthday.map(dateFormatter.string)
    }
    var sexString: Observable<String> {
        return sex.map({ self.sexPickerViewOptions[$0.0] })
    }
    var validInfo: Observable<Void>!
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
    }
    
    func nextSignUpScreen() -> CocoaAction {
        return CocoaAction {
            let viewModel = EmailUsernameViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: SignUpScene.emailUsername(viewModel), type: .push)
        }
    }
    
}
