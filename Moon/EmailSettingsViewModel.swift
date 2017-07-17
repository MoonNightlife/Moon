//
//  EmailSettingsViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/8/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action

struct EmailSettingsViewModel: AuthNetworkingInjected, NetworkingInjected {
    
    var validEmail: Observable<Bool> {
        return newEmailAddress.map(ValidationUtility.validEmail)
    }
    
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    var newEmailAddress = BehaviorSubject<String?>(value: nil)
    
    // Outputs
    var showEmailError: Observable<Bool> {
        return newEmailAddress.filterNil().filter({$0 != ""}).map(ValidationUtility.validEmail).map({!$0})
    }
    
    init(coordinator: SceneCoordinatorType) {
        sceneCoordinator = coordinator
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction {
            return self.sceneCoordinator.pop()
        }
    }
    
    func onUpdateEmail() -> CocoaAction {
        return CocoaAction(enabledIf: validEmail, workFactory: {_ in 
            return Observable.just().withLatestFrom(self.newEmailAddress).filterNil().flatMap({
                return self.userAPI.update(email: $0, for: self.authAPI.SignedInUserID)
            })
            .flatMap({
                return self.sceneCoordinator.pop()
            })
        })
    }
}
