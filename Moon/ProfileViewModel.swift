//
//  ProfileViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/5/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import Action

struct ProfileViewModel {
    
    // Private
    private let disposeBag = DisposeBag()

    // Dependecies
    private let scenceCoordinator: SceneCoordinatorType
    
    // Inputs
    
    // Outputs
    
    init(coordinator: SceneCoordinatorType) {
        self.scenceCoordinator = coordinator
    }
    
    func onDismiss() -> CocoaAction {
        return CocoaAction {
            return self.scenceCoordinator.pop()
        }
    }
}
