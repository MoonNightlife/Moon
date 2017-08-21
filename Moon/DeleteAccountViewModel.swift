//
//  DeleteAccountViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/8/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action

struct DeleteAccountViewModel: AuthNetworkingInjected {
    // Dependencies
    private let sceneCoordinator: SceneCoordinatorType
    
    // Inputs
    
    // Outputs
    
    init(coordinator: SceneCoordinatorType) {
        sceneCoordinator = coordinator
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction {
            return self.sceneCoordinator.pop()
        }
    }
    
    func onDelete() -> CocoaAction {
        return CocoaAction { _ in
            return self.authAPI.deleteAccountForSignedInUser().flatMap({
                return self.showLogin()
            })
        }
    }
    
    func showLogin() -> Observable<Void> {
        let viewModel = LoginViewModel(coordinator: sceneCoordinator)
        let firstScene = Scene.Login.login(viewModel)
        return sceneCoordinator.transition(to: firstScene, type: .root)
    }
    
}
