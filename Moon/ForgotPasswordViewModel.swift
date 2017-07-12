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

struct ForgotPasswordViewModel: AuthNetworkingInjected {
    
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
        return CocoaAction { _ in
            return Observable.just().withLatestFrom(self.email).filterNil().flatMap({
                return self.authAPI.resetPassword(email: $0)
            })
        }
    }
}
