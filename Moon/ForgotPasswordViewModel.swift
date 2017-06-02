//
//  ForgotPasswordViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/2/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action

struct ForgotPasswordViewModel {
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    var email = BehaviorSubject<String?>(value: nil)
    
    // Outputs
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction {
            return self.sceneCoordinator.pop()
        }
    }
    
    func onSendPasswordReset() -> CocoaAction {
        return CocoaAction {
            print("Send Reset")
            return .just()
        }
    }
}
