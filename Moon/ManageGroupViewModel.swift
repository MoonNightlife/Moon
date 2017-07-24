//
//  ManageGroupViewModel.swift
//  Moon
//
//  Created by Evan Noble on 7/23/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Action

struct ManageGroupViewModel: BackType {
    // MARK: - Global
    
    // MARK: - Dependencies
    var sceneCoordinator: SceneCoordinatorType
    
    // MARK: - Actions
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    
    init(sceneCoordinator: SceneCoordinatorType, groupID: String) {
        self.sceneCoordinator = sceneCoordinator
        
    }
    
    func onEdit() -> CocoaAction {
        return CocoaAction {
            let vm = CreateEditGroupViewModel(sceneCoordinator: self.sceneCoordinator, groupID: "123")
            return self.sceneCoordinator.transition(to: Scene.Group.editGroup(vm), type: .push)
        }
    }
}
