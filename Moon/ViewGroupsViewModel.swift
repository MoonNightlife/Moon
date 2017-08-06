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

class ViewGroupsViewModel: NetworkingInjected, AuthNetworkingInjected, StorageNetworkingInjected, ImageNetworkingInjected {
    // MARK: - Global
    
    // MARK: - Dependencies
    var sceneCoordinator: SceneCoordinatorType
    
    // MARK: - Actions
    lazy var getGroups: Action<Void, [GroupSnapshot]> = { this in
        return Action {_ in 
            return this.groupAPI.getGroupsForUser(userID: this.authAPI.SignedInUserID)
        }
    }(self)
    
    lazy var onManageGroup: Action<String, Void> = {
        return Action { [unowned self] groupID in
            let vm = ManageGroupViewModel(sceneCoordinator: self.sceneCoordinator, groupID: groupID)
            return self.sceneCoordinator.transition(to: Scene.Group.manageGroup(vm), type: .modal)
        }
    }()
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    var groupsToDisplay: Observable<[SnapshotSectionModel]> {
        return getGroups.elements
            .map {
                [SnapshotSectionModel(header: "Groups", items: $0)]
            }
    }
    
    init(sceneCoordinator: SceneCoordinatorType) {
        self.sceneCoordinator = sceneCoordinator
    }
    
    func onCreate() -> CocoaAction {
        return CocoaAction { [unowned self] in
            let vm = CreateEditGroupViewModel(sceneCoordinator: self.sceneCoordinator, groupID: nil)
            return self.sceneCoordinator.transition(to: Scene.Group.createGroup(vm), type: .modal)
        }
    }
    
    func viewModelForCell(snapshot: Snapshot) -> BasicImageCellViewModelType {
        return SnapshotBasicImageCellViewModel(snapshot: snapshot, imageSource: .group)
    }
}
