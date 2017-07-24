//
//  ViewGroupsViewModel.swift
//  Moon
//
//  Created by Evan Noble on 7/23/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Action

struct ViewGroupsViewModel {
    // MARK: - Global
    
    // MARK: - Dependencies
    var sceneCoordinator: SceneCoordinatorType
    
    // MARK: - Actions
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    
    init(sceneCoordinator: SceneCoordinatorType) {
        self.sceneCoordinator = sceneCoordinator
    }
    
    func onCreate() -> CocoaAction {
        return CocoaAction {
            let vm = CreateEditGroupViewModel(sceneCoordinator: self.sceneCoordinator, groupID: nil)
            return self.sceneCoordinator.transition(to: Scene.Group.createGroup(vm), type: .modal)
        }
    }
    
    func onViewActivity() -> CocoaAction {
        return CocoaAction {
            let vm = GroupActivityViewModel(sceneCoordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.Group.groupActivity(vm), type: .modal)
        }
    }
    
    func onManageGroup() -> CocoaAction {
        return CocoaAction {
            let vm = ManageGroupViewModel(sceneCoordinator: self.sceneCoordinator, groupID: "123")
            return self.sceneCoordinator.transition(to: Scene.Group.manageGroup(vm), type: .modal)
        }
    }
}
