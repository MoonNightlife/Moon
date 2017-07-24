//
//  CreateEditGroupViewModel.swift
//  Moon
//
//  Created by Evan Noble on 7/23/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Action

struct CreateEditGroupViewModel: BackType {
    // MARK: - Global
    var groupID: String?
    
    // MARK: - Dependencies
    var sceneCoordinator: SceneCoordinatorType
    
    // MARK: - Actions
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    var showBackArrow: Bool {
        // If we are creating a group then the groupID will be nil
        // and we have presented the controller modally, so the arrow
        // should be down instead of back
        return groupID != nil
    }
    
    init(sceneCoordinator: SceneCoordinatorType, groupID: String?) {
        self.sceneCoordinator = sceneCoordinator
        self.groupID = groupID
    }
    
    func onBack() -> CocoaAction {
        return CocoaAction {
            if self.groupID == nil {
                // If we are creating a group then the view was presented modally
                // and can be dismissed noramlly
                return self.sceneCoordinator.pop()
            } else {
                // If we are editing a scene then it was presenting by a navigation controller.
                // To only pop off the edit scene and not dismiss the whole nav view controller
                // we must use this other method, because the navigation controller was presented modally
                return self.sceneCoordinator.popVCOffNavStack(animated: true)
            }
        }
    }
}
