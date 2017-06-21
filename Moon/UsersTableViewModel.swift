//
//  UsersTableViewModel.swift
//  Moon
//
//  Created by Evan Noble on 6/13/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import SwaggerClient

struct UsersTableViewModel: BackType {

    // Dependencies
    let sceneCoordinator: SceneCoordinatorType
    
    // Outputs
    var users: Driver<[UserSnapshot]> = {
//        let userSnapshot = createFakeUsers().map({
//            //return UserSnapshot(name: $0.firstName!, id: $0.id!, picture: #imageLiteral(resourceName: "pic5.jpg"))
//        })
        return Observable.empty().asDriver(onErrorJustReturn: [])
    }()
    
    // Inputs
    
    init(coordinator: SceneCoordinatorType) {
        sceneCoordinator = coordinator
    }
    
    func onShowUser() -> CocoaAction {
        return CocoaAction {
            let vm = ProfileViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.User.profile(vm), type: .popover)
        }
    }
    
    func onShowContacts() -> CocoaAction {
        return CocoaAction {
            let vm = ContactsViewModel(coordinator: self.sceneCoordinator)
            return self.sceneCoordinator.transition(to: Scene.UserDiscovery.contacts(vm), type: .push)
        }
    }
}
