//
//  ViewGroupsViewModel.swift
//  Moon
//
//  Created by Evan Noble on 7/23/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Action
import RxSwift

struct ViewGroupsViewModel: NetworkingInjected {
    // MARK: - Global
    
    // MARK: - Dependencies
    var sceneCoordinator: SceneCoordinatorType
    
    // MARK: - Actions
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    var groupsToDisplay: Observable<[SnapshotSectionModel]> {
        //TODO: Add api call to get groups for user
        return Observable.just([SnapshotSectionModel(header: "Groups", items: [])])
    }
    
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
            //TODO: remove hardcoded group number
            let vm = GroupActivityViewModel(sceneCoordinator: self.sceneCoordinator, groupID: "-KqCrziDBFbqWCkyM9eC")
            return self.sceneCoordinator.transition(to: Scene.Group.groupActivity(vm), type: .modal)
        }
    }
    
    func onManageGroup() -> CocoaAction {
        return CocoaAction {
            //TODO: remove hardcoded group number
            let vm = ManageGroupViewModel(sceneCoordinator: self.sceneCoordinator, groupID: "-KqCrziDBFbqWCkyM9eC")
            return self.sceneCoordinator.transition(to: Scene.Group.manageGroup(vm), type: .modal)
        }
    }
}
