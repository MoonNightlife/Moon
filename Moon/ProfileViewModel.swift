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
    
    func onShowFriends() -> CocoaAction {
        return CocoaAction {
            let vm = UsersTableViewModel(coordinator: self.scenceCoordinator)
            return self.scenceCoordinator.transition(to: Scene.User.usersTable(vm), type: .modal)
        }
    }
    
    func onEdit() -> CocoaAction {
        return CocoaAction {
            let vm = EditProfileViewModel(coordinator: self.scenceCoordinator)
            return self.scenceCoordinator.transition(to: Scene.User.edit(vm), type: .modal)
        }
    }
    
}
