//
//  RelationshipViewModel.swift
//  Moon
//
//  Created by Evan Noble on 7/23/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import Action

struct RelationshipViewModel: BackType {
    // MARK: - Global
    
    // MARK: - Dependencies
    var sceneCoordinator: SceneCoordinatorType
    
    // MARK: - Actions
    lazy var onChangeChildView: Action<View.Relationship, Void> = { this in
        return Action {
            return this.sceneCoordinator.changeChild(To: $0)
        }
    }(self)
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    
    init(sceneCoordinator: SceneCoordinatorType) {
        self.sceneCoordinator = sceneCoordinator
        
    }
    
    func onShowContacts() -> CocoaAction {
        return CocoaAction {
            let vm = ContactsViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.UserDiscovery.contacts(vm), type: .modal)
        }
    }
}
